import 'package:very_good_cofee_app/core/failures.dart';
import 'package:very_good_cofee_app/core/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';

/// Repository interface for fetching coffee data.
///
/// Provides methods to retrieve coffee data from data sources.
abstract interface class CoffeeRepository {
  /// Fetches a random coffee.
  ///
  /// Returns a [Result] containing a [CoffeeModel] on success, or a [Failure] on error.
  Future<Result<CoffeeModel>> fetchCoffee();
}
