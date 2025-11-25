import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_cofee_app/core/clients/shared_preferences_client.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_local_data_source.dart';

class MockSharedPreferencesClient extends Mock
    implements SharedPreferencesClient {}

void main() {
  group('CoffeeLocalDataSource', () {
    late CoffeeLocalDataSource dataSource;
    late MockSharedPreferencesClient mockSharedPreferencesClient;

    setUp(() {
      mockSharedPreferencesClient = MockSharedPreferencesClient();
      dataSource = CoffeeLocalDataSource(
        sharedPreferencesClient: mockSharedPreferencesClient,
      );
    });

    const favoritesKey = 'favorites';
    const testImageUrl = 'https://coffee.example.com/image.jpg';
    const anotherImageUrl = 'https://coffee.example.com/another.jpg';
    final testCoffeeModel = CoffeeModel(imageUrl: testImageUrl);
    final anotherCoffeeModel = CoffeeModel(imageUrl: anotherImageUrl);
    final testCoffeeJson = '{"file": "$testImageUrl"}';
    final anotherCoffeeJson = '{"file": "$anotherImageUrl"}';

    group('getFavorites', () {
      test('returns Ok with List<CoffeeModel> on success', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenAnswer((_) async => [testCoffeeJson, anotherCoffeeJson]);

        final result = await dataSource.getFavorites();

        expect(result, isA<Ok<List<CoffeeModel>>>());
        expect((result as Ok<List<CoffeeModel>>).value, [
          testCoffeeModel,
          anotherCoffeeModel,
        ]);
        verify(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).called(1);
      });

      test('returns Error<...> on exception', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenThrow(Exception('Boom!'));

        final result = await dataSource.getFavorites();

        expect(result, isA<Error<List<CoffeeModel>>>());
        final error = result as Error<List<CoffeeModel>>;
        expect(error.failure, isA<LocalStorageFailure>());
        expect(
          error.failure.message,
          contains('Something went wrong while loading your favorite coffees'),
        );
        verify(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).called(1);
      });
    });

    group('addToFavorites', () {
      test(
        'adds coffee when not already favorite and returns Ok<void>',
        () async {
          when(
            () => mockSharedPreferencesClient.readStringList(favoritesKey),
          ).thenAnswer((_) async => []);
          when(
            () => mockSharedPreferencesClient.writeStringList(
              favoritesKey,
              any(),
            ),
          ).thenAnswer((_) async {
            return true;
          });

          final result = await dataSource.addToFavorites(testCoffeeModel);

          expect(result, isA<Ok<void>>());
          verify(
            () => mockSharedPreferencesClient.readStringList(favoritesKey),
          ).called(1);
          verify(
            () => mockSharedPreferencesClient.writeStringList(favoritesKey, [
              testCoffeeModel.toJson(),
            ]),
          ).called(1);
        },
      );

      test('does nothing if coffee already exists, returns Ok<void>', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenAnswer((_) async => [testCoffeeJson]);

        final result = await dataSource.addToFavorites(testCoffeeModel);

        expect(result, isA<Ok<void>>());
        verify(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).called(1);
        verifyNever(
          () => mockSharedPreferencesClient.writeStringList(any(), any()),
        );
      });

      test('returns propagation Error if getFavorites fails', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenThrow(Exception('Storage failure'));

        final result = await dataSource.addToFavorites(testCoffeeModel);

        expect(result, isA<Error<void>>());
        expect((result as Error<void>).failure, isA<LocalStorageFailure>());
      });

      test(
        'returns Error if an exception is thrown during add logic',
        () async {
          when(
            () => mockSharedPreferencesClient.readStringList(favoritesKey),
          ).thenAnswer((_) async => []);
          when(
            () => mockSharedPreferencesClient.writeStringList(any(), any()),
          ).thenThrow(Exception('Write failed'));

          final result = await dataSource.addToFavorites(testCoffeeModel);

          expect(result, isA<Error<void>>());
          expect((result as Error<void>).failure, isA<LocalStorageFailure>());
          expect(result.failure.message, contains('adding a coffee'));
        },
      );
    });

    group('removeFromFavorites', () {
      test('removes coffee and returns Ok<void> when present', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenAnswer((_) async => [testCoffeeJson, anotherCoffeeJson]);
        when(
          () => mockSharedPreferencesClient.writeStringList(favoritesKey, [
            anotherCoffeeModel.toJson(),
          ]),
        ).thenAnswer((_) async {
          return true;
        });

        final result = await dataSource.removeFromFavorites(testCoffeeModel);

        expect(result, isA<Ok<void>>());
        verify(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).called(1);
        verify(
          () => mockSharedPreferencesClient.writeStringList(favoritesKey, [
            anotherCoffeeModel.toJson(),
          ]),
        ).called(1);
      });

      test('does nothing and returns Ok<void> if coffee not present', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenAnswer((_) async => [anotherCoffeeJson]);
        when(
          () => mockSharedPreferencesClient.writeStringList(any(), any()),
        ).thenAnswer((_) async {
          return true;
        });

        final result = await dataSource.removeFromFavorites(testCoffeeModel);

        expect(result, isA<Ok<void>>());
        verify(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).called(1);
        verify(
          () => mockSharedPreferencesClient.writeStringList(favoritesKey, [
            anotherCoffeeModel.toJson(),
          ]),
        ).called(1);
      });

      test('returns propagation Error if getFavorites fails', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenThrow(Exception('Failed read'));

        final result = await dataSource.removeFromFavorites(testCoffeeModel);

        expect(result, isA<Error<void>>());
        expect((result as Error<void>).failure, isA<LocalStorageFailure>());
      });

      test('returns Error if exception thrown during removal logic', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenAnswer((_) async => [testCoffeeJson]);
        when(
          () => mockSharedPreferencesClient.writeStringList(any(), any()),
        ).thenThrow(Exception('Remove fail'));

        final result = await dataSource.removeFromFavorites(testCoffeeModel);

        expect(result, isA<Error<void>>());
        expect((result as Error).failure, isA<LocalStorageFailure>());
        expect(
          result.failure.message,
          contains('removing a coffee from favorites'),
        );
      });
    });

    group('isCoffeeFavorite', () {
      test('returns Ok(true) when coffee is favorite', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenAnswer((_) async => [testCoffeeJson, anotherCoffeeJson]);

        final result = await dataSource.isCoffeeFavorite(testCoffeeModel);

        expect(result, isA<Ok<bool>>());
        expect((result as Ok<bool>).value, isTrue);
      });

      test('returns Ok(false) when coffee is not favorite', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenAnswer((_) async => [anotherCoffeeJson]);

        final result = await dataSource.isCoffeeFavorite(testCoffeeModel);

        expect(result, isA<Ok<bool>>());
        expect((result as Ok<bool>).value, isFalse);
      });

      test('returns Error<bool> if getFavorites fails', () async {
        when(
          () => mockSharedPreferencesClient.readStringList(favoritesKey),
        ).thenThrow(Exception('Fail'));

        final result = await dataSource.isCoffeeFavorite(testCoffeeModel);

        expect(result, isA<Error<bool>>());
        expect((result as Error<bool>).failure, isA<LocalStorageFailure>());
      });
    });
  });
}
