import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// A simple HTTP client for performing network requests.
class MainHttpClient {
  MainHttpClient({@visibleForTesting http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  /// Sends an HTTP GET request to the specified [url].
  ///
  /// Returns the response body as a [String] if the request is successful (status code 200).
  /// Throws an [Exception] if the request fails.
  Future<String> get(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        return response.body;
      }

      throw Exception(
        'Request failed with the statusCode: ${response.statusCode})',
      );
    } catch (e) {
      rethrow;
    }
  }
}
