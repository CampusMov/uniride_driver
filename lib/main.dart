import 'package:flutter/material.dart';
import 'package:uniride_driver/features/auth/presentation/pages/code_verification_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:CodeVerificationPage(),
      
    );
  }
}
