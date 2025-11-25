import 'package:very_good_coffee_app/core/failures/failure.dart';
import 'package:very_good_coffee_app/core/results/result.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';

/// Repository interface for fetching coffee data.
///
/// Provides methods to retrieve coffee data from data sources.
abstract interface class CoffeeRepository {
  /// Fetches a random coffee.
  ///
  /// Returns a [Result] containing a [CoffeeModel] on success, or a [Failure] on error.
  Future<Result<CoffeeModel>> fetchCoffee();

  /// Gets the favorite coffees.
  ///
  /// Returns a [Result] containing a [List<CoffeeModel>] on success,
  /// or a [Failure] on error.
  Future<Result<List<CoffeeModel>>> getFavorites();

  /// Adds the given [coffee] to the favorites list.
  ///
  /// Returns a [Result] which is `Ok` with `void` on success,
  /// or `Error` with a [Failure] on failure.
  Future<Result<void>> addToFavorites(CoffeeModel coffee);

  /// Removes the given [coffee] from the favorites list.
  ///
  /// Returns a [Result] which is `Ok` with `void` on success,
  /// or `Error` with a [Failure] on failure.
  Future<Result<void>> removeFromFavorites(CoffeeModel coffee);

  /// Checks whether the given [coffee] is in the favorites list.
  ///
  /// Returns a [Result] which is `Ok` with `true` if the coffee is a favorite,
  /// `false` if not, or `Error` with a [Failure] on failure.
  Future<Result<bool>> isCoffeeFavorite(CoffeeModel coffee);
}
