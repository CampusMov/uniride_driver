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
              const SizedBox(height: 20),

              _buildOptionItem(context, 'Información personal', const PersonalInfoScreen()),
              _buildOptionItem(context, 'Información de contacto', const ContactInfoScreen()),
              _buildOptionItem(context, 'Información académica', const AcademicInfoScreen()),
              _buildOptionItem(context, 'Información del vehículo', const VehicleInfoScreen()),
              _buildOptionItem(context, 'Términos y condiciones', const TermsAndConditionsScreen()),
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '¡Comenzar!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, String text, Widget destinationScreen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destinationScreen),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
          const Divider(color: Colors.white, thickness: 0.75),
        ],
      ),
    );
  }
}
