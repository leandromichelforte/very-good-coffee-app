import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee_app/core/clients/main_http_client.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('MainHttpClient', () {
    late MainHttpClient mainHttpClient;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mainHttpClient = MainHttpClient(client: mockHttpClient);
    });

    group('get', () {
      const testUrl = 'https://example.com/api/data';
      const testResponseBody = '{"file": "https://example.com/coffee.jpg"}';

      test('should return response body when status code is 200', () async {
        when(
          () => mockHttpClient.get(Uri.parse(testUrl)),
        ).thenAnswer((_) async => http.Response(testResponseBody, 200));

        final result = await mainHttpClient.get(testUrl);

        expect(result, equals(testResponseBody));
        verify(() => mockHttpClient.get(Uri.parse(testUrl))).called(1);
      });

      test('should throw Exception when status code is not 200', () async {
        when(
          () => mockHttpClient.get(Uri.parse(testUrl)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(
          () => mainHttpClient.get(testUrl),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Request failed with the statusCode: 404'),
            ),
          ),
        );
        verify(() => mockHttpClient.get(Uri.parse(testUrl))).called(1);
      });

      test('should rethrow exceptions from http client', () async {
        when(
          () => mockHttpClient.get(Uri.parse(testUrl)),
        ).thenThrow(Exception('Network error'));

        expect(
          () => mainHttpClient.get(testUrl),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Network error'),
            ),
          ),
        );
        verify(() => mockHttpClient.get(Uri.parse(testUrl))).called(1);
      });
    });
  });
}
