part of 'coffee_cubit.dart';

sealed class CoffeeState extends Equatable {
  const CoffeeState();

  @override
  List<Object> get props => [];
}

final class CoffeeInitial extends CoffeeState {
  const CoffeeInitial();
}

final class CoffeeLoadInProgress extends CoffeeState {
  const CoffeeLoadInProgress();
}

class CoffeeLoadSuccess extends CoffeeState {
  const CoffeeLoadSuccess({required this.coffee, this.isFavorite = false});

  final CoffeeModel coffee;
  final bool isFavorite;

  @override
  List<Object> get props => [coffee, isFavorite];
}

final class CoffeeLoadFailure extends CoffeeState {
  const CoffeeLoadFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

final class CoffeeAddToFavoritesLoadInProgress extends CoffeeLoadSuccess {
  const CoffeeAddToFavoritesLoadInProgress({
    required super.coffee,
    super.isFavorite,
  });
}

final class CoffeeAddToFavoritesSuccess extends CoffeeLoadSuccess {
  const CoffeeAddToFavoritesSuccess({required super.coffee, super.isFavorite});
}

final class CoffeeAddToFavoritesFailure extends CoffeeLoadSuccess {
  const CoffeeAddToFavoritesFailure({required super.coffee, super.isFavorite});
}

final class CoffeeRemoveFromFavoritesLoadInProgress extends CoffeeLoadSuccess {
  const CoffeeRemoveFromFavoritesLoadInProgress({
    required super.coffee,
    super.isFavorite,
  });
}

final class CoffeeRemoveFromFavoritesSuccess extends CoffeeLoadSuccess {
  const CoffeeRemoveFromFavoritesSuccess({
    required super.coffee,
    super.isFavorite,
  });
}

final class CoffeeRemoveFromFavoritesFailure extends CoffeeLoadSuccess {
  const CoffeeRemoveFromFavoritesFailure({
    required super.coffee,
    super.isFavorite,
  });
}
