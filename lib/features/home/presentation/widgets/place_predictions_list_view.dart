import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_event.dart';

class PlacePredictionsListView extends StatelessWidget {
  const PlacePredictionsListView({super.key, required this.predictions, required this.isMode});
  

  final List<Prediction> predictions;
  final bool isMode;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: predictions.map((prediction) {
          return Column(
            children: [
              ListTile(
                leading: IconButton(
                  icon: Icon(
                    prediction.isFavorite ? Icons.star : Icons.star_border,
                    color: prediction.isFavorite ? Colors.amber : Colors.grey,
                    size: 24,
                  ),
                  onPressed: (){
                    // Usar el BLoC para agregar favorito
                    prediction.isFavorite ?
                    context.read<FavoritesBloc>().add(RemoveFavorite(placeId: prediction.placeId)) :
                    context.read<FavoritesBloc>().add(AddFavorite(prediction: prediction));
                    
                    
                    // Mostrar confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lugar agregado a favoritos'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                ),
                title: Text(prediction.description, style: TextStylePaletter.subTextOptions,),
                onTap: () {
                  // Creamo evento para obtener las coordenadas de la dirección seleccionada
                  isMode ? 
                  context.read<SelectLocationBloc>().add(GetLocationOrigin(address: prediction.description)) :
                  context.read<SelectLocationBloc>().add(GetLocationDestination(address: prediction.description));
                  //context.read<SelectLocationBloc>().add(UpdateSelecLocation(location: prediction.description));
                  Navigator.of(context).pop();
                },

              ),
              const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}