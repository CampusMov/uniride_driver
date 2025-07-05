
import 'package:sqflite/sqflite.dart';
import 'package:uniride_driver/core/database/database_helper.dart';
import 'package:uniride_driver/features/home/data/model/place_favorite_model.dart';
import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';


class PlaceFavoriteDao  {

 
  Future<void> addFavorite(Prediction prediction) async {
    try {
      var favorite = PlaceFavoriteModel( 
        placeId: prediction.placeId, 
        address: prediction.description,
        isFavorite: true // Cambiar a true cuando se agrega a favoritos
      );

      final db = await DatabaseHelper.instance.database;

      await db.insert(
        DatabaseHelper.placeFavoritesTable,
        favorite.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String placeId) async {
    final db = await DatabaseHelper.instance.database;
    
    await db.delete(
      DatabaseHelper.placeFavoritesTable,
      where: 'place_id = ?',
      whereArgs: [placeId],
    );
  }

  Future<List<Prediction>> getAllFavorites() async {
    try {
      final db = await DatabaseHelper.instance.database;
      
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.placeFavoritesTable
      );
      
      if (maps.isNotEmpty) {
        return maps.map((favorite) => Prediction(
          placeId: favorite['place_id'],
          description: favorite['address'],
          isFavorite: favorite['isfavorite'] == 1, // Convertir de int a bool
        )).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  Future<bool> isFavorite(String placeId) async {
    final db = await DatabaseHelper.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.placeFavoritesTable,
      where: 'place_id = ?',
      whereArgs: [placeId],
    );
    
    return maps.isNotEmpty;
  }

  
}