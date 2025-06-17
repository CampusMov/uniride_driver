import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';
import 'package:uniride_driver/core/ui/custom_text_field.dart';
import 'package:uniride_driver/features/home/domain/entities/location_favorite.dart';
import 'package:uniride_driver/features/home/presentation/widgets/card_location_view.dart';
import 'package:uniride_driver/features/home/presentation/widgets/location_favorite_list_view.dart';

class PositionSelectionPage extends StatefulWidget {
  const PositionSelectionPage({super.key});

  @override
  State<PositionSelectionPage> createState() => _PositionSelectionPageState();
}

class _PositionSelectionPageState extends State<PositionSelectionPage> {
  final List<LocationFavorite> _locationsFavorites = [ ];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    
    _locationsFavorites.add(
      LocationFavorite(
        nameLocation: "Casa",
        isFavorite: true,
        address: "Calle Falsa 123",
      ),
    );

    _locationsFavorites.add(
      LocationFavorite(
        nameLocation: "Casa",
        isFavorite: false,
        address: "Calle Falsa 123",
      ),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ 
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, 
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
                "de partida",
                style: TextStylePaletter.title,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        CustomTextField(
          icon: Icon(Icons.search, color: ColorPaletter.textPrimary),
          editingController: _searchController,
          hintText: 'Buscar punto de partida',
        ),
        SizedBox(height: 20),
       Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Ubicaciones guardadas:",style: TextStylePaletter.textOptions,),
         ],
       ),
       SizedBox(height: 10),

       LocationFavoriteListView(locations: _locationsFavorites)
        

       
      ],
    );
  }
}