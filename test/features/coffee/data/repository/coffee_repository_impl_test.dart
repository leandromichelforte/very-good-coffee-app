import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee_app/core/failures/failure.dart';
import 'package:very_good_coffee_app/core/results/result.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_coffee_app/features/coffee/data/repository/coffee_repository_impl.dart';
import 'package:very_good_coffee_app/features/coffee/data/sources/coffee_remote_data_source.dart';
import 'package:very_good_coffee_app/features/coffee/data/sources/coffee_local_data_source.dart';

class MockCoffeeRemoteDataSource extends Mock
    implements CoffeeRemoteDataSource {}

class MockCoffeeLocalDataSource extends Mock implements CoffeeLocalDataSource {}

void main() {
  group('CoffeeRepositoryImpl', () {
    late MockCoffeeRemoteDataSource mockRemoteDataSource;
    late MockCoffeeLocalDataSource mockLocalDataSource;
    late CoffeeRepositoryImpl coffeeRepository;

    setUp(() {
      mockRemoteDataSource = MockCoffeeRemoteDataSource();
      mockLocalDataSource = MockCoffeeLocalDataSource();
      coffeeRepository = CoffeeRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    final mockCoffeeModel = CoffeeModel(
      imageUrl: 'https://coffee.example.com/image.jpg',
    );

    group('fetchCoffee', () {
      test('returns Ok with CoffeeModel on success', () async {
        when(
          () => mockRemoteDataSource.fetchCoffee(),
        ).thenAnswer((_) async => Result.ok(mockCoffeeModel));

        final result = await coffeeRepository.fetchCoffee();

        expect(result, isA<Ok<CoffeeModel>>());
        expect((result as Ok<CoffeeModel>).value, equals(mockCoffeeModel));
        verify(() => mockRemoteDataSource.fetchCoffee()).called(1);
      });

      test('returns Error with NetworkFailure', () async {
        const failure = NetworkFailure(message: 'No connection');
        when(
          () => mockRemoteDataSource.fetchCoffee(),
        ).thenAnswer((_) async => Result.error(failure));

        final result = await coffeeRepository.fetchCoffee();

        expect(result, isA<Error<CoffeeModel>>());
        final errorResult = result as Error<CoffeeModel>;
        expect(errorResult.failure, isA<NetworkFailure>());
        expect(errorResult.failure.message, equals('No connection'));
        verify(() => mockRemoteDataSource.fetchCoffee()).called(1);
      });

      test('returns Error with UnknownFailure', () async {
        const failure = UnknownFailure(message: 'Something bad happened');
        when(
          () => mockRemoteDataSource.fetchCoffee(),
        ).thenAnswer((_) async => Result.error(failure));

        final result = await coffeeRepository.fetchCoffee();

        expect(result, isA<Error<CoffeeModel>>());
        final errorResult = result as Error<CoffeeModel>;
        expect(errorResult.failure, isA<UnknownFailure>());
        expect(errorResult.failure.message, equals('Something bad happened'));
        verify(() => mockRemoteDataSource.fetchCoffee()).called(1);
      });
    });

    group('getFavorites', () {
      test('returns Ok with list of CoffeeModel on success', () async {
        final favList = [mockCoffeeModel];
        when(
          () => mockLocalDataSource.getFavorites(),
        ).thenAnswer((_) async => Result.ok(favList));

        final result = await coffeeRepository.getFavorites();

        expect(result, isA<Ok<List<CoffeeModel>>>());
        expect((result as Ok<List<CoffeeModel>>).value, equals(favList));
        verify(() => mockLocalDataSource.getFavorites()).called(1);
      });

      test('returns Error with LocalStorageFailure', () async {
        const failure = LocalStorageFailure(message: 'Error loading favorites');
        when(
          () => mockLocalDataSource.getFavorites(),
        ).thenAnswer((_) async => Result.error(failure));

        final result = await coffeeRepository.getFavorites();

        expect(result, isA<Error<List<CoffeeModel>>>());
        final errorResult = result as Error<List<CoffeeModel>>;
        expect(errorResult.failure, isA<LocalStorageFailure>());
        expect(errorResult.failure.message, equals('Error loading favorites'));
        verify(() => mockLocalDataSource.getFavorites()).called(1);
      });
    });

    group('addToFavorites', () {
      test('returns Ok<void> on success', () async {
        when(
          () => mockLocalDataSource.addToFavorites(mockCoffeeModel),
        ).thenAnswer((_) async => Result.ok(null));

        final result = await coffeeRepository.addToFavorites(mockCoffeeModel);

        expect(result, isA<Ok<void>>());
        verify(
          () => mockLocalDataSource.addToFavorites(mockCoffeeModel),
        ).called(1);
      });

      test('returns Error with LocalStorageFailure', () async {
        const failure = LocalStorageFailure(message: 'Error adding favorite');
        when(
          () => mockLocalDataSource.addToFavorites(mockCoffeeModel),
        ).thenAnswer((_) async => Result.error(failure));

        final result = await coffeeRepository.addToFavorites(mockCoffeeModel);

        expect(result, isA<Error<void>>());
        final errorResult = result as Error<void>;
        expect(errorResult.failure, isA<LocalStorageFailure>());
        expect(errorResult.failure.message, equals('Error adding favorite'));
        verify(
          () => mockLocalDataSource.addToFavorites(mockCoffeeModel),
        ).called(1);
      });
    });

    group('removeFromFavorites', () {
      test('returns Ok<void> on success', () async {
        when(
          () => mockLocalDataSource.removeFromFavorites(mockCoffeeModel),
        ).thenAnswer((_) async => Result.ok(null));

        final result = await coffeeRepository.removeFromFavorites(
          mockCoffeeModel,
        );

        expect(result, isA<Ok<void>>());
        verify(
          () => mockLocalDataSource.removeFromFavorites(mockCoffeeModel),
        ).called(1);
      });

      test('returns Error with LocalStorageFailure', () async {
        const failure = LocalStorageFailure(message: 'Error removing favorite');
        when(
          () => mockLocalDataSource.removeFromFavorites(mockCoffeeModel),
        ).thenAnswer((_) async => Result.error(failure));

        final result = await coffeeRepository.removeFromFavorites(
          mockCoffeeModel,
        );

        expect(result, isA<Error<void>>());
        final errorResult = result as Error<void>;
        expect(errorResult.failure, isA<LocalStorageFailure>());
        expect(errorResult.failure.message, equals('Error removing favorite'));
        verify(
          () => mockLocalDataSource.removeFromFavorites(mockCoffeeModel),
        ).called(1);
      });
    });

    group('isCoffeeFavorite', () {
      test('returns Ok<bool> with true when coffee is favorite', () async {
        when(
          () => mockLocalDataSource.isCoffeeFavorite(mockCoffeeModel),
        ).thenAnswer((_) async => Result.ok(true));

        final result = await coffeeRepository.isCoffeeFavorite(mockCoffeeModel);

        expect(result, isA<Ok<bool>>());
        expect((result as Ok<bool>).value, true);
        verify(
          () => mockLocalDataSource.isCoffeeFavorite(mockCoffeeModel),
        ).called(1);
      });

      test('returns Ok<bool> with false when coffee is not favorite', () async {
        when(
          () => mockLocalDataSource.isCoffeeFavorite(mockCoffeeModel),
        ).thenAnswer((_) async => Result.ok(false));

        final result = await coffeeRepository.isCoffeeFavorite(mockCoffeeModel);

        expect(result, isA<Ok<bool>>());
        expect((result as Ok<bool>).value, false);
        verify(
          () => mockLocalDataSource.isCoffeeFavorite(mockCoffeeModel),
        ).called(1);
      });

      test('returns Error with LocalStorageFailure', () async {
        const failure = LocalStorageFailure(message: 'Error checking favorite');
        when(
          () => mockLocalDataSource.isCoffeeFavorite(mockCoffeeModel),
        ).thenAnswer((_) async => Result.error(failure));

        final result = await coffeeRepository.isCoffeeFavorite(mockCoffeeModel);

        expect(result, isA<Error<bool>>());
        final errorResult = result as Error<bool>;
        expect(errorResult.failure, isA<LocalStorageFailure>());
        expect(errorResult.failure.message, equals('Error checking favorite'));
        verify(
          () => mockLocalDataSource.isCoffeeFavorite(mockCoffeeModel),
        ).called(1);
      });
    });
  });
}
