class PlaceFavoriteModel {
  final String placeId;
  final String address;
  final bool isFavorite;


  const PlaceFavoriteModel({

    required this.placeId,
    required this.address,
    required this.isFavorite,

  });

  // Convertir de Map a PlaceFavorite
  factory PlaceFavoriteModel.fromMap(Map<String, dynamic> map) {
    return PlaceFavoriteModel(

      placeId: map['place_id'] ?? '',
  
      address: map['address'] ?? '',

      isFavorite: map['isfavorite'] == 1, // Convertir de int a bool
      
    );
  }

  // Convertir de PlaceFavorite a json
  Map<String, dynamic> toJson() {
    return {

      'place_id': placeId,
      
      'address': address,

      'isfavorite': isFavorite ? 1 : 0, // Convertir de bool a int
      
    };
  }

 

 

  

 
}
