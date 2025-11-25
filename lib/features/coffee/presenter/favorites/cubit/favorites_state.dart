part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoadInProgress extends FavoritesState {
  const FavoritesLoadInProgress();
}

class FavoritesLoadSuccess extends FavoritesState {
  const FavoritesLoadSuccess({required this.favorites});

  final List<CoffeeModel> favorites;

  @override
  List<Object> get props => [favorites];
}

final class FavoritesLoadFailure extends FavoritesState {
  const FavoritesLoadFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

final class RemoveFromFavoritesSuccess extends FavoritesLoadSuccess {
  const RemoveFromFavoritesSuccess({required super.favorites});
}

final class RemoveFromFavoritesFailure extends FavoritesLoadSuccess {
  const RemoveFromFavoritesFailure({required super.favorites});
}
