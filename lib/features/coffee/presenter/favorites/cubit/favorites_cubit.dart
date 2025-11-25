import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';

part 'favorites_state.dart';

/// A Cubit responsible for managing and emitting states related to the user's favorite coffees.
///
/// Provides methods to load the list of favorites and remove a coffee from the favorites,
/// emitting corresponding states during these processes.
class FavoritesCubit extends Cubit<FavoritesState> {
  /// Creates a [FavoritesCubit] with the given [CoffeeRepository].
  FavoritesCubit({required CoffeeRepository coffeeRepository})
    : _coffeeRepository = coffeeRepository,
      super(const FavoritesInitial());

  final CoffeeRepository _coffeeRepository;

  /// Loads the user's favorite coffees from the repository and emits loading,
  /// success, or failure states accordingly.
  void loadFavorites() async {
    emit(const FavoritesLoadInProgress());
    final favoritesResult = await _coffeeRepository.getFavorites();

    switch (favoritesResult) {
      case Ok<List<CoffeeModel>>():
        final favorites = favoritesResult.value;
        emit(FavoritesLoadSuccess(favorites: favorites));
        break;
      case Error():
        emit(FavoritesLoadFailure(failure: favoritesResult.failure));
        break;
    }
  }

  /// Removes the given [coffee] from the user's favorites, and emits a success or failure state.
  /// After a successful removal, reloads the current favorites list.
  void removeFromFavorites(CoffeeModel coffee) async {
    final currentState = state;
    if (currentState is! FavoritesLoadSuccess) return;

    final removeFromFavoritesResult = await _coffeeRepository
        .removeFromFavorites(coffee);

    switch (removeFromFavoritesResult) {
      case Ok<void>():
        emit(RemoveFromFavoritesSuccess(favorites: currentState.favorites));
        loadFavorites();
        break;
      case Error():
        emit(RemoveFromFavoritesFailure(favorites: currentState.favorites));
        break;
    }
  }
}
