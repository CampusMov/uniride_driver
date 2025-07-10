import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/navigation/screens_routes.dart';
import 'package:uniride_driver/features/onboarding/presentation/blocs/skip_login_bloc.dart';
import 'package:uniride_driver/features/onboarding/presentation/blocs/skip_login_event.dart';
import 'package:uniride_driver/features/onboarding/presentation/blocs/skip_login_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      context.read<SkipLoginBloc>().add(LoadUserLocally());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    log('TAG: splashscreen - xd');
    return BlocListener<SkipLoginBloc, SkipLoginState>(
      listener: (context, state) {
        if (state.isUserLoaded) {
          Navigator.pushReplacementNamed(context, ScreensRoutes.searchCarpool);
        } else if (state.errorMessage != null) {
          Navigator.pushReplacementNamed(context, ScreensRoutes.welcome);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Image.asset('assets/images/login_logo.png')),
      ),
    );
  }

}