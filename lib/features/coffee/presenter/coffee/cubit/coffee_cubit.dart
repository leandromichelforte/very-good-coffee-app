import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_app/core/failures/failure.dart';
import 'package:very_good_coffee_app/core/results/result.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_coffee_app/features/coffee/data/repository/coffee_repository.dart';

part 'coffee_state.dart';

/// A Cubit responsible for managing and emitting states related to fetching coffee data.
class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit({required CoffeeRepository coffeeRepository})
    : _coffeeRepository = coffeeRepository,
      super(const CoffeeInitial());

  final CoffeeRepository _coffeeRepository;

  /// Requests a new coffee from the repository and updates the state to loading, success, or failure.
  void fetchCoffee() async {
    emit(const CoffeeLoadInProgress());

    final coffeeResult = await _coffeeRepository.fetchCoffee();

    switch (coffeeResult) {
      case Ok<CoffeeModel>():
        final coffee = coffeeResult.value;
        final isFavoriteResult = await _coffeeRepository.isCoffeeFavorite(
          coffee,
        );
        final isFavorite = switch (isFavoriteResult) {
          Ok(:final value) => value,
          Error() => false,
        };

        emit(CoffeeLoadSuccess(coffee: coffee, isFavorite: isFavorite));
        break;
      case Error():
        emit(CoffeeLoadFailure(failure: coffeeResult.failure));
        break;
    }
  }

  /// Adds the given [coffee] to the favorites and updates the state accordingly.
  void addToFavorites(CoffeeModel coffee) async {
    // It's needed to show the Snackbar as many times the user gets
    // the failure state. It doesn't trigger additional build methods.
    emit(CoffeeAddToFavoritesLoadInProgress(coffee: coffee));

    final addToFavoritesResult = await _coffeeRepository.addToFavorites(coffee);

    switch (addToFavoritesResult) {
      case Ok<void>():
        emit(CoffeeAddToFavoritesSuccess(coffee: coffee, isFavorite: true));
        break;
      case Error():
        emit(CoffeeAddToFavoritesFailure(coffee: coffee, isFavorite: false));
        break;
    }
  }

  /// Removes the given [coffee] from the favorites and emits new state.
  void removeFromFavorites(CoffeeModel coffee) async {
    // It's needed to show the Snackbar as many times the user gets
    // the failure state. It doesn't trigger additional build methods.
    emit(CoffeeRemoveFromFavoritesLoadInProgress(coffee: coffee));

    final removeFromFavoritesResult = await _coffeeRepository
        .removeFromFavorites(coffee);

    switch (removeFromFavoritesResult) {
      case Ok<void>():
        emit(
          CoffeeRemoveFromFavoritesSuccess(coffee: coffee, isFavorite: false),
        );
        break;
      case Error():
        emit(
          CoffeeRemoveFromFavoritesFailure(coffee: coffee, isFavorite: true),
        );
        break;
    }
  }

  /// Checks whether the currently loaded coffee is still marked as favorite and updates state if needed.
  void syncIsFavorite() async {
    final currentState = state;
    if (currentState is! CoffeeLoadSuccess) return;

    final isFavoriteResult = await _coffeeRepository.isCoffeeFavorite(
      currentState.coffee,
    );
    final isFavorite = switch (isFavoriteResult) {
      Ok(:final value) => value,
      Error() => false,
    };

    emit(
      CoffeeLoadSuccess(coffee: currentState.coffee, isFavorite: isFavorite),
    );
  }
}
