import 'package:flutter/material.dart';

// Clase simple para representar un pasajero/solicitud
class PassengerRequest {
  final String id;
  final String name;
  final String rating;
  final String location;
  final String price;

  PassengerRequest({
    required this.id,
    required this.name,
    required this.rating,
    required this.location,
    required this.price,
  });
}

class RequestPassengersPage extends StatefulWidget {
  const RequestPassengersPage({super.key});

  @override
  State<RequestPassengersPage> createState() => _RequestPassengersPageState();
}

class _RequestPassengersPageState extends State<RequestPassengersPage> {
  // Lista de pasajeros ya aceptados
  List<PassengerRequest> acceptedPassengers = [
  ];

  // Lista de solicitudes pendientes
  List<PassengerRequest> pendingRequests = [
    PassengerRequest(
      id: '3',
      name: 'Gustavo Antonio Perez Rojas',
      rating: '0',
      location: 'Universidad de Lima',
      price: 'S/5.10',
    ),
  ];

  // Función para aceptar una solicitud
  void _acceptRequest(PassengerRequest request) {
    setState(() {
      pendingRequests.removeWhere((p) => p.id == request.id);
      acceptedPassengers.add(request);
    });

    // Mostrar mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud de ${request.name} aceptada'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Función para rechazar una solicitud
  void _rejectRequest(PassengerRequest request) {
    setState(() {
      pendingRequests.removeWhere((p) => p.id == request.id);
    });

    // Mostrar mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud de ${request.name} rechazada'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título Pasajeros
            Text(
              'Pasajeros',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Lista de pasajeros aceptados
            if (acceptedPassengers.isEmpty)
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No hay pasajeros aceptados aún',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              )
            else
              ...acceptedPassengers.map((passenger) =>
                  _buildPassengerCard(passenger, true)
              ).toList(),

            SizedBox(height: 40),

            // Título Lista de solicitudes
            Text(
              'Lista de solicitudes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Lista de solicitudes pendientes
            if (pendingRequests.isEmpty)
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No hay solicitudes pendientes',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              )
            else
              ...pendingRequests.map((request) =>
                  _buildPassengerCard(request, false)
              ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerCard(PassengerRequest passenger, bool isAccepted) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[700],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text(passenger.rating, style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        passenger.name,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.grey[400], size: 16),
                    SizedBox(width: 4),
                    Text(passenger.location, style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
                SizedBox(height: 4),
                Text(passenger.price, style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),

          // Botón derecho
          if (isAccepted)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.chat_outlined, color: Colors.white),
                    onPressed: () {
                      // Aquí podrías abrir el chat
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Abrir chat con ${passenger.name}')),
                      );
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('1', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                SizedBox(width: 10),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey[600]!),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _acceptRequest(passenger),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, size: 16),
                          SizedBox(width: 4),
                          Text('Aceptar'),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _rejectRequest(passenger),
                      child: Text('Rechazar', style: TextStyle(color: Colors.grey[400])),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}