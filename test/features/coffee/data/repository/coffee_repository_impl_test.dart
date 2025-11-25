import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository_impl.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

class MockCoffeeRemoteDataSource extends Mock
    implements CoffeeRemoteDataSource {}

void main() {
  group('CoffeeRepositoryImpl', () {
    late MockCoffeeRemoteDataSource mockRemoteDataSource;
    late CoffeeRepositoryImpl coffeeRepository;

    setUp(() {
      mockRemoteDataSource = MockCoffeeRemoteDataSource();
      coffeeRepository = CoffeeRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
      );
    });

    final mockCoffeeModel = CoffeeModel(
      imageUrl: 'https://coffee.example.com/image.jpg',
    );

    test('fetchCoffee returns Ok with CoffeeModel on success', () async {
      when(
        () => mockRemoteDataSource.fetchCoffee(),
      ).thenAnswer((_) async => Result.ok(mockCoffeeModel));

      final result = await coffeeRepository.fetchCoffee();

      expect(result, isA<Ok<CoffeeModel>>());
      expect((result as Ok<CoffeeModel>).value, equals(mockCoffeeModel));
      verify(() => mockRemoteDataSource.fetchCoffee()).called(1);
    });

    test('fetchCoffee returns Error with NetworkFailure', () async {
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

    test('fetchCoffee returns Error with UnknownFailure', () async {
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
}
