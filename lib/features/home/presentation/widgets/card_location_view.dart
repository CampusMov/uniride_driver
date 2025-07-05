import 'package:flutter/material.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/core/theme/text_style_paletter.dart';

import 'package:uniride_driver/features/home/domain/entities/location_favorite.dart';

class CardLocationView extends StatelessWidget {
  const CardLocationView({super.key,required this.locationFavorite});

  final LocationFavorite locationFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      color:  Color.fromARGB(0, 231, 10, 10),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    
                  },
                  icon: Icon(locationFavorite.isFavorite ? Icons.star: Icons.star_border_outlined, color:ColorPaletter.textPrimary ),
                  style: IconButton.styleFrom(
                    backgroundColor: ColorPaletter.inputField,
                    shape: CircleBorder(),
                  )),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locationFavorite.nameLocation, style: TextStylePaletter.body,),
                      SizedBox(height: 10),
                      Text(locationFavorite.address,style: TextStylePaletter.spam,)
                    ],
                  )
                ],
                
              )
            ),
            
          ],
        ),
      ) ,
    );
  }
}