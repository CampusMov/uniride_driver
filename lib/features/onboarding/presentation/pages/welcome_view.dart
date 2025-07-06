import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/home/domain/repositories/route_repository.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_bloc.dart';
import 'package:uniride_driver/features/home/presentation/pages/home_page.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../auth/presentation/pages/enter_institutional_email_page.dart';
import '../../../shared/utils/widgets/circle_indicator.dart';
import '../../../shared/utils/widgets/default_rounded_text_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'UniRide',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Welcome banner image
            Container(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.asset(
                'assets/images/start_image.png',
                width: double.infinity,
                height: 280,
                fit: BoxFit.contain,
              ),
            ),

            // Title and description text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 18.0),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                      'Comparte tu viaje y gana más',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 18.0),
                    child: const Text(
                      'Crea los carpools que mejor te funcionen',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom section with indicators, button and terms
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Page indicators
                  SizedBox(
                    width: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CircleIndicator(
                          color: Color(0xFFD9D9D9),
                          size: 10,
                        ),
                        CircleIndicator(
                          color: Color(0xFF7B7B7B),
                          size: 10,
                        ),
                      ],
                    ),
                  ),

                  // Continue button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 13.0,
                    ),
                    child: DefaultRoundedTextButton(
                      text: 'Continuar',
                      onPressed: () {
                        Navigator.push(
                          context,
                          //Modifique el la routa para entrar mas facil al home Brayan Eliminar
                          MaterialPageRoute(builder: (context) => BlocProvider(
                              create: (context) => SelectLocationBloc(),
                              child: BlocProvider(
                                create: (context) => MapBloc(
                                    routeRepository: di.sl<RouteRepository>()
                                ),
                                child: BlocProvider(
                                  create: (context)=> FavoritesBloc(),
                                  child: const HomePage())
                              ),
                            ),),
                        );
                      },
                    ),
                  ),

                  // Terms and privacy text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      bottom: 50.0,
                      left: 13.0,
                      right: 13.0,
                    ),
                    child: const Text(
                      'Al unirte a nuestra aplicación, aceptas nuestro Terminos de uso y Política de privacidad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF98999B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}