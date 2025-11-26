import 'dart:io';

import 'package:very_good_coffee_app/core/clients/main_http_client.dart';
import 'package:very_good_coffee_app/core/failures/failure.dart';
import 'package:very_good_coffee_app/core/results/result.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';

/// Data source class responsible for fetching coffee data from a remote API.
class CoffeeRemoteDataSource {
  const CoffeeRemoteDataSource({required MainHttpClient mainHttpClient})
    : _mainHttpClient = mainHttpClient,
      _coffeeUrl = 'https://coffee.alexflipnote.dev/random.json';

  final MainHttpClient _mainHttpClient;
  final String _coffeeUrl;

  /// Fetches a random coffee from the remote API.
  ///
  /// Returns a [Result] containing a [CoffeeModel] on success, or a [Failure]
  /// on error.
  Future<Result<CoffeeModel>> fetchCoffee() async {
    try {
      final response = await _mainHttpClient.get(_coffeeUrl);
      final coffee = CoffeeModel.fromJson(response);

      return Result.ok(coffee);
    } on SocketException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } catch (e) {
      return Result.error(
        UnknownFailure(message: 'An unexpected error occurred:\n\n$e'),
      );
    }
  }
}
