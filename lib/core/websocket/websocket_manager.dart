import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:uniride_driver/core/constants/api_constants.dart';

import '../../features/home/domain/entities/enum_passenger_request_status.dart';
import '../events/app_event_bus.dart';
import '../../features/home/data/model/passenger_request_response_model.dart';
import '../events/app_events.dart';

enum WebSocketConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal();

  // State of each microservice connection
  final Map<String, StompClient> _connections = {};
  final Map<String, WebSocketConnectionStatus> _connectionStatuses = {};
  final Map<String, Map<String, StompUnsubscribe>> _subscriptionsByService = {};
  final Map<String, Timer> _reconnectTimers = {};
  final Map<String, String> _serviceUrls = {};

  String? _currentUserId;

  // Stream controllers for connection status
  final Map<String, StreamController<WebSocketConnectionStatus>> _statusControllers = {};

  /// Get the singleton instance of WebSocketManager
  WebSocketConnectionStatus getConnectionStatus(String serviceName) {
    return _connectionStatuses[serviceName] ?? WebSocketConnectionStatus.disconnected;
  }

  /// Stream for connection status of a specific service
  Stream<WebSocketConnectionStatus> getConnectionStatusStream(String serviceName) {
    _statusControllers[serviceName] ??= StreamController<WebSocketConnectionStatus>.broadcast();
    return _statusControllers[serviceName]!.stream;
  }

  /// Connect to a specific microservice
  Future<void> connectToService({
    required String serviceName,
    required String wsUrl,
  }) async
  {
    if (_connectionStatuses[serviceName] == WebSocketConnectionStatus.connected) {
      log('TAG: WebSocketManager - Already connected to $serviceName');
      return;
    }

    _serviceUrls[serviceName] = wsUrl;
    _updateConnectionStatus(serviceName, WebSocketConnectionStatus.connecting);

    try {
      final stompClient = StompClient(
        config: StompConfig(
          url: wsUrl,
          onConnect: (frame) => _onConnect(serviceName, frame),
          onDisconnect: (frame) => _onDisconnect(serviceName, frame),
          onStompError: (frame) => _onStompError(serviceName, frame),
          onWebSocketError: (error) => _onWebSocketError(serviceName, error),
          onDebugMessage: (message) {
            log('TAG: WebSocketManager - [$serviceName] Debug: $message');
          },
          // Config to handle reconnections
          reconnectDelay: const Duration(seconds: 5),
          heartbeatIncoming: const Duration(seconds: 30),
          heartbeatOutgoing: const Duration(seconds: 30),
        ),
      );

      _connections[serviceName] = stompClient;
      _subscriptionsByService[serviceName] = {};

      stompClient.activate();
      log('TAG: WebSocketManager - Connecting to $serviceName at: $wsUrl');
    } catch (e) {
      log('TAG: WebSocketManager - [$serviceName] Connection error: $e');
      _updateConnectionStatus(serviceName, WebSocketConnectionStatus.error);
    }
  }

  /// Disconnect from a specific microservice
  void disconnectFromService(String serviceName) {
    _reconnectTimers[serviceName]?.cancel();
    _reconnectTimers.remove(serviceName);

    // Clear subscriptions for the service
    _clearServiceSubscriptions(serviceName);

    if (_connections[serviceName] != null) {
      _connections[serviceName]!.deactivate();
      _connections.remove(serviceName);
    }

    _updateConnectionStatus(serviceName, WebSocketConnectionStatus.disconnected);
    log('TAG: WebSocketManager - Disconnected from $serviceName');
  }

  /// Disconnect from all microservices
  void disconnectFromAllServices() {
    final serviceNames = List<String>.from(_connections.keys);
    for (final serviceName in serviceNames) {
      disconnectFromService(serviceName);
    }
  }

  /// Subscribe to a specific topic in a microservice
  void subscribeToTopic({
    required String serviceName,
    required String topic,
    required String subscriptionKey,
    required Function(Map<String, dynamic>) onMessage,
  })
  {
    if (_connectionStatuses[serviceName] != WebSocketConnectionStatus.connected) {
      log('TAG: WebSocketManager - [$serviceName] Cannot subscribe, not connected');
      return;
    }

    final client = _connections[serviceName]!;
    final serviceSubscriptions = _subscriptionsByService[serviceName]!;

    // If already subscribed, skip subscription
    if (serviceSubscriptions.containsKey(subscriptionKey)) {
      log('TAG: WebSocketManager - [$serviceName] Already subscribed to $subscriptionKey');
      return;
    }

    try {
      final unsubscribe = client.subscribe(
        destination: topic,
        callback: (StompFrame frame) {
          _handleMessage(serviceName, topic, frame, onMessage);
        },
      );

      serviceSubscriptions[subscriptionKey] = unsubscribe;
      log('TAG: WebSocketManager - [$serviceName] Subscribed to $topic');
    } catch (e) {
      log('TAG: WebSocketManager - [$serviceName] Error subscribing to $topic: $e');
    }
  }

  /// Handle incoming messages from a subscription
  void _handleMessage(
      String serviceName,
      String topic,
      StompFrame frame,
      Function(Map<String, dynamic>) onMessage,
      )
  {
    try {
      if (frame.body == null) return;

      final jsonData = json.decode(frame.body!);
      log('TAG: WebSocketManager - [$serviceName] Received message on $topic: $jsonData');

      onMessage(jsonData);
    } catch (e) {
      log('TAG: WebSocketManager - [$serviceName] Error handling message: $e');
    }
  }

  /// Unsubscribe from a specific topic in a microservice
  void unsubscribeFromTopic(String serviceName, String subscriptionKey) {
    final serviceSubscriptions = _subscriptionsByService[serviceName];

    if (serviceSubscriptions != null && serviceSubscriptions.containsKey(subscriptionKey)) {
      serviceSubscriptions[subscriptionKey]!();
      serviceSubscriptions.remove(subscriptionKey);
      log('TAG: WebSocketManager - [$serviceName] Unsubscribed from $subscriptionKey');
    }
  }

  /// Send a message to a specific destination in a microservice
  Future<void> sendMessage({
    required String serviceName,
    required String destination,
    required Map<String, dynamic> payload,
  }) async
  {
    if (_connectionStatuses[serviceName] != WebSocketConnectionStatus.connected) {
      log('TAG: WebSocketManager - [$serviceName] Cannot send message, not connected');
      return;
    }

    try {
      final client = _connections[serviceName]!;
      client.send(
        destination: destination,
        body: json.encode(payload),
        headers: {'content-type': 'application/json'},
      );

      log('TAG: WebSocketManager - [$serviceName] Sent message to $destination');
    } catch (e) {
      log('TAG: WebSocketManager - [$serviceName] Error sending message: $e');
    }
  }

  // ========== SPECIFIC SERVICE METHODS ==========

  /// MATCHING-ROUTING SERVICE - Subscribe to passenger request created
  void subscribeToPassengerRequestInCarpool(String carpoolId) {
    subscribeToTopic(
      serviceName: '${ApiConstants.webSocketUrl}${ApiConstants.routingMatchingServiceName}',
      topic: '/topic/carpools/$carpoolId/passenger-requests/status',
      subscriptionKey: 'carpool_${carpoolId}_passenger_requests',
      onMessage: (data) => _handlePassengerRequestUpdate(data, carpoolId),
    );
  }

  void _handlePassengerRequestUpdate(Map<String, dynamic> data, String carpoolId) {
    try {
      final passengerRequest = PassengerRequestResponseModel.fromJson(data).toDomain();

      // Emit events based on the passenger request status
      switch (passengerRequest.status) {
        case PassengerRequestStatus.pending:
          log('TAG: WebSocketManager - Passenger request received for carpool $carpoolId: ${passengerRequest.toString()}');
          AppEventBus().emit(PassengerRequestReceived(passengerRequest));
          break;
        case PassengerRequestStatus.accepted:
          log('TAG: WebSocketManager - Passenger request accepted for carpool $carpoolId: ${passengerRequest.toString()}');
          AppEventBus().emit(PassengerRequestAccepted(passengerRequest));
          break;
        case PassengerRequestStatus.rejected:
          log('TAG: WebSocketManager - Passenger request rejected for carpool $carpoolId: ${passengerRequest.toString()}');
          AppEventBus().emit(PassengerRequestRejected(passengerRequest));
          break;
        case PassengerRequestStatus.cancelled:
          log('TAG: WebSocketManager - Passenger request cancelled for carpool $carpoolId: ${passengerRequest.toString()}');
          AppEventBus().emit(PassengerRequestCancelled(passengerRequest));
          break;
      }
    } catch (e) {
      log('TAG: WebSocketManager - Error handling passenger request update: $e');
    }
  }

  // ========== CALLBACKS AND HANDLERS ==========

  void _onConnect(String serviceName, StompFrame frame) {
    log('TAG: WebSocketManager - [$serviceName] Connected');
    _updateConnectionStatus(serviceName, WebSocketConnectionStatus.connected);
    _reconnectTimers[serviceName]?.cancel();
    _reconnectTimers.remove(serviceName);

    // Emit if connected successfully
    AppEventBus().emit(WebSocketServiceConnected(serviceName));
  }

  void _onDisconnect(String serviceName, StompFrame frame) {
    log('TAG: WebSocketManager - [$serviceName] Disconnected');
    _updateConnectionStatus(serviceName, WebSocketConnectionStatus.disconnected);
    _clearServiceSubscriptions(serviceName);

    // Retry if the service is disconnected
    _scheduleReconnect(serviceName);

    // Emit if disconnected
    AppEventBus().emit(WebSocketServiceDisconnected(serviceName));
  }

  void _onStompError(String serviceName, StompFrame frame) {
    log('TAG: WebSocketManager - [$serviceName] STOMP Error: ${frame.body}');
    _updateConnectionStatus(serviceName, WebSocketConnectionStatus.error);

    // Emit error event
    AppEventBus().emit(WebSocketServiceError(serviceName, frame.body ?? 'Unknown STOMP error'));
  }

  void _onWebSocketError(String serviceName, dynamic error) {
    log('TAG: WebSocketManager - [$serviceName] WebSocket Error: $error');
    _updateConnectionStatus(serviceName, WebSocketConnectionStatus.error);

    // Emit error event
    AppEventBus().emit(WebSocketServiceError(serviceName, error.toString()));
  }

  void _scheduleReconnect(String serviceName) {
    if (_reconnectTimers[serviceName] != null) return;

    _updateConnectionStatus(serviceName, WebSocketConnectionStatus.reconnecting);

    _reconnectTimers[serviceName] = Timer(const Duration(seconds: 5), () {
      log('TAG: WebSocketManager - [$serviceName] Attempting to reconnect...');
      final url = _serviceUrls[serviceName];
      if (url != null && _currentUserId != null) {
        connectToService(
          serviceName: serviceName,
          wsUrl: url,
        );
      }
      _reconnectTimers.remove(serviceName);
    });
  }

  void _updateConnectionStatus(String serviceName, WebSocketConnectionStatus status) {
    _connectionStatuses[serviceName] = status;

    if (_statusControllers[serviceName] != null) {
      _statusControllers[serviceName]!.add(status);
    }

    log('TAG: WebSocketManager - [$serviceName] Connection status changed to: $status');
  }

  void _clearServiceSubscriptions(String serviceName) {
    final serviceSubscriptions = _subscriptionsByService[serviceName];
    if (serviceSubscriptions != null) {
      for (final unsubscribe in serviceSubscriptions.values) {
        unsubscribe();
      }
      serviceSubscriptions.clear();
      log('TAG: WebSocketManager - [$serviceName] Cleared all subscriptions');
    }
  }

  /// Dispose method to clean up resources
  void dispose() {
    disconnectFromAllServices();
    for (final controller in _statusControllers.values) {
      controller.close();
    }
    _statusControllers.clear();
  }
}