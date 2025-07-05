import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';

abstract class FavoritesState {
  const FavoritesState();
}
class InitialState extends FavoritesState {
  
}

class LoadingState extends FavoritesState {
  
}

class LoadedState extends FavoritesState {

  final List<Prediction> predictions;
  
  LoadedState({required this.predictions});

}

