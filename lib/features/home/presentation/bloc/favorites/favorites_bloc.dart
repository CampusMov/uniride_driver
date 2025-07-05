import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/home/data/repositories/place_favorite_dao.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/favorites/favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent,FavoritesState>{
  FavoritesBloc() : super(InitialState()) {
    
    on<InitialFavorites>((event, emit) async {
      emit(LoadingState());
      // Simulate a delay for loading
      final placeFavoriteDao = PlaceFavoriteDao();

      final predictions = await placeFavoriteDao.getAllFavorites();
      
      emit(LoadedState(predictions: predictions)); // Replace with actual data
    });
      
    on<AddFavorite>((event, emit) async {
      try {
        emit(LoadingState());
        
        final placeFavoriteDao = PlaceFavoriteDao();
        await placeFavoriteDao.addFavorite(event.prediction);
        
        // Recargar la lista de favoritos después de agregar
        final predictions = await placeFavoriteDao.getAllFavorites();
        emit(LoadedState(predictions: predictions));
      } catch (e) {
        emit(InitialState()); // En caso de error, volver al estado inicial
      }
    });
  }
}