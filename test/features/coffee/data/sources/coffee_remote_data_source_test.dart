import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_cofee_app/core/clients/main_http_client.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

class MockMainHttpClient extends Mock implements MainHttpClient {}

void main() {
  group('CoffeeRemoteDataSource', () {
    late CoffeeRemoteDataSource dataSource;
    late MockMainHttpClient mockMainHttpClient;

    setUp(() {
      mockMainHttpClient = MockMainHttpClient();
      dataSource = CoffeeRemoteDataSource(mainHttpClient: mockMainHttpClient);
    });

    const testCoffeeJson = '{"file": "https://coffee.example.com/image.jpg"}';
    final expectedCoffeeModel = CoffeeModel(
      imageUrl: "https://coffee.example.com/image.jpg",
    );

    test('fetchCoffee returns Ok with CoffeeModel on success', () async {
      when(
        () => mockMainHttpClient.get(any()),
      ).thenAnswer((_) async => testCoffeeJson);

      final result = await dataSource.fetchCoffee();

      expect(result, isA<Ok<CoffeeModel>>());
      expect((result as Ok<CoffeeModel>).value, equals(expectedCoffeeModel));
      verify(
        () => mockMainHttpClient.get(
          'https://coffee.alexflipnote.dev/random.json',
        ),
      ).called(1);
    });

    test(
      'fetchCoffee returns Error with NetworkFailure on SocketException',
      () async {
        const errorMessage = 'No Internet!';
        when(
          () => mockMainHttpClient.get(any()),
        ).thenThrow(SocketException(errorMessage));

        final result = await dataSource.fetchCoffee();

        expect(result, isA<Error<CoffeeModel>>());
        final errorResult = result as Error<CoffeeModel>;
        expect(errorResult.failure, isA<NetworkFailure>());
        expect(errorResult.failure.message, equals(errorMessage));
        verify(
          () => mockMainHttpClient.get(
            'https://coffee.alexflipnote.dev/random.json',
          ),
        ).called(1);
      },
    );

    test(
      'fetchCoffee returns Error with UnknownFailure on generic exception',
      () async {
        const exceptionText = 'Something went wrong!';
        when(
          () => mockMainHttpClient.get(any()),
        ).thenThrow(Exception(exceptionText));

        final result = await dataSource.fetchCoffee();

        expect(result, isA<Error<CoffeeModel>>());
        final errorResult = result as Error<CoffeeModel>;
        expect(errorResult.failure, isA<UnknownFailure>());
        expect(errorResult.failure.message, contains(exceptionText));
        verify(
          () => mockMainHttpClient.get(
            'https://coffee.alexflipnote.dev/random.json',
          ),
        ).called(1);
      },
    );
  });
}
