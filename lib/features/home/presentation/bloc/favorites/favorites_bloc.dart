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
      emit(LoadingState());
        
        final placeFavoriteDao = PlaceFavoriteDao();
        await placeFavoriteDao.addFavorite(event.prediction);
        
        // Recargar la lista de favoritos después de agregar
        final predictions = await placeFavoriteDao.getAllFavorites();
        emit(LoadedState(predictions: predictions));
    });

    on<RemoveFavorite>((event, emit) async {
      emit(LoadingState());
        
        final placeFavoriteDao = PlaceFavoriteDao();
        await placeFavoriteDao.removeFavorite(event.placeId);
        
        // Recargar la lista de favoritos después de eliminar
        final predictions = await placeFavoriteDao.getAllFavorites();
        emit(LoadedState(predictions: predictions));
    });
  }
}