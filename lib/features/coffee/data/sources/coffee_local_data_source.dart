import 'package:very_good_coffee_app/core/clients/shared_preferences_client.dart';
import 'package:very_good_coffee_app/core/failures/failure.dart';
import 'package:very_good_coffee_app/core/results/result.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';

/// Data source class responsible for managing coffee data in local storage.
///
/// Provides methods to access, add, remove, and check favorite coffees
/// in device local storage.
class CoffeeLocalDataSource {
  /// Creates a new [CoffeeLocalDataSource] with the given shared preferences client.
  const CoffeeLocalDataSource({
    required SharedPreferencesClient sharedPreferencesClient,
  }) : _sharedPreferencesClient = sharedPreferencesClient,
       _key = 'favorites';

  final SharedPreferencesClient _sharedPreferencesClient;
  final String _key;

  /// Retrieves the list of favorite coffees from local storage.
  ///
  /// Returns a [Result] containing a [List<CoffeeModel>] on success,
  /// or a [Failure] on error.
  Future<Result<List<CoffeeModel>>> getFavorites() async {
    try {
      final favoritesJson = await _sharedPreferencesClient.readStringList(_key);

      final favorites = favoritesJson
          .map((json) => CoffeeModel.fromJson(json))
          .toList();

      return Result.ok(favorites);
    } catch (e) {
      return Result.error(
        LocalStorageFailure(
          message:
              'Something went wrong while loading your favorite coffees\n\n$e',
        ),
      );
    }
  }

  /// Adds a [coffee] to the local favorites list.
  ///
  /// Returns a [Result] which is `Ok` on success or `Error` on failure.
  Future<Result<void>> addToFavorites(CoffeeModel coffee) async {
    try {
      final favoritesResult = await getFavorites();

      switch (favoritesResult) {
        case Ok<List<CoffeeModel>>():
          final favorites = favoritesResult.value;

          // Avoid duplicated items
          if (!favorites.any((c) => c.imageUrl == coffee.imageUrl)) {
            favorites.add(coffee);

            final favoritesJson = favorites.map((c) => c.toJson()).toList();

            await _sharedPreferencesClient.writeStringList(_key, favoritesJson);
          }

          return Result.ok(null);

        case Error():
          return Result.error(favoritesResult.failure);
      }
    } catch (e) {
      return Result.error(
        LocalStorageFailure(
          message:
              'Something went wrong while adding a coffee to your favorites\n\n$e',
        ),
      );
    }
  }

  /// Removes a [coffee] from the local favorites list.
  ///
  /// Returns a [Result] which is `Ok` on success or `Error` on failure.
  Future<Result<void>> removeFromFavorites(CoffeeModel coffee) async {
    try {
      final favoritesResult = await getFavorites();

      switch (favoritesResult) {
        case Ok<List<CoffeeModel>>():
          final favorites = favoritesResult.value;

          // Remove the item with the matching imageUrl
          favorites.removeWhere((c) => c.imageUrl == coffee.imageUrl);

          final favoritesJson = favorites.map((c) => c.toJson()).toList();

          await _sharedPreferencesClient.writeStringList(_key, favoritesJson);

          return Result.ok(null);

        case Error():
          return Result.error(favoritesResult.failure);
      }
    } catch (e) {
      return Result.error(
        LocalStorageFailure(
          message:
              'Something went wrong while removing a coffee from favorites\n\n$e',
        ),
      );
    }
  }

  /// Checks whether a [coffee] is in the favorites list in local storage.
  ///
  /// Returns a [Result] which is `Ok` with [true] if the coffee is a favorite,
  /// [false] if not, or `Error` on failure.
  Future<Result<bool>> isCoffeeFavorite(CoffeeModel coffee) async {
    final favoritesResult = await getFavorites();

    return switch (favoritesResult) {
      Ok<List<CoffeeModel>>(:final value) => Result.ok(
        value.any((c) => c.imageUrl == coffee.imageUrl),
      ),
      Error(:final failure) => Result.error(failure),
    };
  }
}
