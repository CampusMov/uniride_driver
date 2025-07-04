import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_bloc.dart';
import 'package:uniride_driver/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Initialize the app

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          //Provider debe tener un bloc
          BlocProvider<MapBloc>(create: (context) => MapBloc()),
          BlocProvider<SelectLocationBloc>(create:(context) => SelectLocationBloc())
        ], 
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomePage(),
        },

      )
    );
  }
}
