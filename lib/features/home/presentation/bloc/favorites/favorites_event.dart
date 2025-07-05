import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';

abstract class FavoritesEvent {
  const FavoritesEvent();
}

class InitialFavorites extends FavoritesEvent{

 InitialFavorites();
}

class AddFavorite extends FavoritesEvent {

  final Prediction prediction;

  AddFavorite({required this.prediction});
}