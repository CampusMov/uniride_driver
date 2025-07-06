import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/core/ui/custom_text_field.dart';
import 'package:uniride_driver/features/home/domain/entities/location_favorite.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_state.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_state.dart';
import 'package:uniride_driver/features/home/presentation/widgets/place_predictions_list_view.dart';

class PositionSelectionPageOrigin extends StatefulWidget {
  const PositionSelectionPageOrigin({super.key,required this.onTap});

  
  final VoidCallback onTap;
  
  @override
  State<PositionSelectionPageOrigin> createState() => _PositionSelectionPageOriginState();
}

class _PositionSelectionPageOriginState extends State<PositionSelectionPageOrigin> {
  final List<LocationFavorite> _locationsFavorites = [ ];
  final TextEditingController _searchController = TextEditingController();

  

  @override
  void initState() {
    context.read<FavoritesBloc>().add(InitialFavorites());
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPaletter.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ 
                IconButton(onPressed: widget.onTap, 
                icon: Icon(Icons.close, color: ColorPaletter.textPrimary),
                  style: IconButton.styleFrom(
                    backgroundColor: ColorPaletter.inputField,
                    shape: CircleBorder(),
                  )),
              ],
            ),
            Center(
              child: Column(
                children: [
                  
                  Text(
                    "Ingresa tu punto",
                    style: TextStylePaletter.title,
                  ),
                  Text(
                    "de partida" ,
                    style: TextStylePaletter.title,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              icon: Icon(Icons.search, color: ColorPaletter.textPrimary),
              editingController: _searchController,
              onChanged: (value){
                //Emitir un evento al cambio de texto
        
              },
              onSubmitted: (value){
                //Envia evento para obtener los resultados posibles
                context.read<SelectLocationBloc>().add(SearchOriginLocation(query: value));
              },
              hintText: 'Buscar punto de partida',
            ),
        
            //Aca ,uesta la actualizacion de la ubicacion
            BlocBuilder<SelectLocationBloc,SelectLocationState>(
              builder: (context,state){
                if (state is SelectLocationLive ) {
                  return Text(state.location);
                  
                }else if(state is SelectLocationLoadesOrigin){
                  return Text(state.locationOrigin.address,style: TextStylePaletter.welcomeSubTitle);
                
                } else if(state is SelectLocationSearch ){
                  return PlacePredictionsListView(
                    predictions: state.predictions, isMode: true,);
                }
                return Text("Esperando ubicación...");
                
              }),
            SizedBox(height: 20),
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Ubicaciones guardadas:",style: TextStylePaletter.textOptions,),
             ],
           ),
           SizedBox(height: 10),

            // Lista de ubicaciones favoritas
            BlocBuilder<FavoritesBloc,FavoritesState>(
              builder: (context,state){
                if (state is InitialState ) {
                  return Text("No hay ubicaciones guardadas",style: TextStylePaletter.welcomeSubTitle);
                  
                }else if(state is LoadingState){
                  return Center(
                        child: CircularProgressIndicator(
                          color: ColorPaletter.background,
                        ),
                    );
                
                } else if(state is LoadedState ){
                  return PlacePredictionsListView(
                    predictions: state.predictions, isMode: true,);
                }
                return Text("Esperando ubicación...");
                
              }),
           
            
        
           
          ],
        ),
        ),
      ),
    );
  }
}