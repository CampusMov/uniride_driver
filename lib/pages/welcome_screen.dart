import 'package:flutter/material.dart';
import 'package:uniride_driver/pages/academic_info_screen.dart';
import 'package:uniride_driver/pages/contact_info_screen.dart';
import 'package:uniride_driver/pages/personal_info_screen.dart';
import 'package:uniride_driver/pages/terms_and_conditions_screen.dart';
import 'package:uniride_driver/pages/vehicle_info_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final String name;

  const WelcomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido, $name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Esto es todo lo que debes hacer para configurar su cuenta',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),

              // Botones centrados y de igual tamaño
              Center(
                child: Column(
                  children: [
                    _buildOptionButton(context, 'Información personal', const PersonalInfoScreen()),
                    _buildOptionButton(context, 'Información de contacto', const ContactInfoScreen()),
                    _buildOptionButton(context, 'Información académica', const AcademicInfoScreen()),
                    _buildOptionButton(context, 'Información del vehículo', const VehicleInfoScreen()),
                    _buildOptionButton(context, 'Términos y condiciones', const TermsAndConditionsScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String text, Widget destinationScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => destinationScreen),
            );
          },
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
