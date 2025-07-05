import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_bloc.dart';
import 'package:uniride_driver/features/home/presentation/pages/home_page.dart';
import 'package:uniride_driver/core/navigation/screens_routes.dart';
import 'package:uniride_driver/features/auth/presentation/pages/enter_institutional_email_page.dart';
import 'package:uniride_driver/features/auth/presentation/pages/verification_code_page.dart';
import 'package:uniride_driver/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:uniride_driver/features/onboarding/presentation/pages/welcome_view.dart';
import 'package:uniride_driver/features/profile/presentantion/pages/register_profile_academic_info_page.dart';
import 'package:uniride_driver/features/profile/presentantion/pages/register_profile_accept_terms_page.dart';
import 'package:uniride_driver/features/profile/presentantion/pages/register_profile_contact_info_page.dart';
import 'package:uniride_driver/features/profile/presentantion/pages/register_profile_personal_info_page.dart';
import 'package:uniride_driver/firebase_options.dart';

import 'core/di/injection_container.dart' as di;
import 'features/profile/presentantion/pages/register_profile_full_name_page.dart';
import 'features/profile/presentantion/pages/register_profile_list_sections_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  // Initialize dependencies
  await di.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Initialize the app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'UniRide',
        theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    initialRoute: ScreensRoutes.home,
    routes: {
      ScreensRoutes.home : (context) => const SplashScreen(),
      ScreensRoutes.welcome : (context) => const WelcomeView(),
      ScreensRoutes.enterInstitutionalEmail : (context) => const EnterInstitutionalEmailPage(),
      ScreensRoutes.enterVerificationCode : (context) => const VerificationCodePage(),
      ScreensRoutes.registerProfileFullName : (context) => const RegisterProfileFullNamePage(),
      ScreensRoutes.registerProfileListSections : (context) => const RegisterProfileListSectionsPage(),
      ScreensRoutes.registerProfilePersonalInformation : (context) => const RegisterProfilePersonalInfoPage(),
      ScreensRoutes.registerProfileContactInformation : (context) => const RegisterProfileContactInfoPage(),
      ScreensRoutes.registerProfileAcademicInformation : (context) => const RegisterProfileAcademicInfoPage(),
      ScreensRoutes.registerProfileAcceptTermsAndConditions : (context) => const RegisterProfileAcceptTermsPage(),
      // TODO: Add the actual SearchCarpoolPage implementation
      ScreensRoutes.searchCarpool : (context) => const Placeholder(),
    });
  }
}
