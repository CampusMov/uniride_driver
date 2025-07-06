import 'package:flutter/material.dart';

class RequestPassengersPage extends StatelessWidget {
  const RequestPassengersPage({super.key});

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
            
            // Pasajeros
            _buildSimpleCard('Pedro Ruiz Gallo', '3.6', 'Lince', 'S/5.10', true),
            _buildSimpleCard('Pedro Ruiz Gallo', '3.6', 'Lince', 'S/5.10', true),
            
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
            
            // Solicitudes
            _buildSimpleCard('Pedro Ruiz Gallo', '3.6', 'Lince', 'S/5.10', false),
            _buildSimpleCard('Pedro Ruiz Gallo', '3.6', 'Lince', 'S/5.10', false),
            _buildSimpleCard('Pedro Ruiz Gallo', '3.6', 'Lince', 'S/5.10', false),
            _buildSimpleCard('Pedro Ruiz Gallo', '3.6', 'Lince', 'S/5.10', false),
            _buildSimpleCard('Pedro Ruiz Gallo', '3.6', 'Lince', 'S/5.10', false),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleCard(String name, String rating, String location, String price, bool hasChat) {
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
                    Text(rating, style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name, 
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
                    Text(location, style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
                SizedBox(height: 4),
                Text(price, style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),
          
          // Botón derecho
          if (hasChat)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.chat_outlined, color: Colors.white),
                    onPressed: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
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