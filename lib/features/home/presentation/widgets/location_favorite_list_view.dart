import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:uniride_driver/features/home/domain/entities/location_favorite.dart';
import 'package:uniride_driver/features/home/presentation/widgets/card_location_view.dart';

class LocationFavoriteListView extends StatelessWidget {
  const LocationFavoriteListView({super.key, required this.locations});

  final List<LocationFavorite> locations;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Altura ajustada para reducir el tamaño de las tarjetas
      child: GridView.builder(
        itemCount: locations.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3.4,
        ),
        itemBuilder: (context, index) {
          final LocationFavorite location = locations[index];
          return CardLocationView(locationFavorite: location);
        },
      ),
    );
  }
}