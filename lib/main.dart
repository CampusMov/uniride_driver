import 'package:flutter/material.dart';
import 'package:uniride_driver/features/auth/presentation/pages/enter_institutional_email_page.dart';
import 'package:uniride_driver/features/onboarding/presentation/pages/splash_screen.dart';

import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'UniRide',
        theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    home: const SplashScreen(),
    routes: {
      '/enter-verification-code': (context) => const EnterInstitutionalEmailPage(),
    });
  }
}
