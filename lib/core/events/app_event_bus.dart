import 'dart:async';
import 'dart:developer';
import 'app_events.dart';

/*
* Event Bus singleton that allows communication between different parts of the application
* Allows emitting and listening to events without tight coupling between components.
 */
class AppEventBus {
  static final AppEventBus _instance = AppEventBus._internal();
  factory AppEventBus() => _instance;
  AppEventBus._internal();

  final StreamController<AppEvent> _controller = StreamController<AppEvent>.broadcast();

  /*
  * Stream of AppEvents that allows listening to all events emitted in the application.
  * */
  Stream<AppEvent> get events => _controller.stream;

  /*
  * Stream of specific AppEvents that allows listening to events of a specific type.
  * */
  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  /*
  * Emit an AppEvent to the stream.
  * */
  void emit(AppEvent event) {
    log('TAG: AppEventBus - Emitting event: ${event.runtimeType}');
    _controller.add(event);
  }

  /*
  * Dispose the event bus to close the stream controller.
  * This should be called when the application is shutting down
  * or when the event bus is no longer needed to prevent memory leaks.
  * */
  void dispose() {
    _controller.close();
  }
}