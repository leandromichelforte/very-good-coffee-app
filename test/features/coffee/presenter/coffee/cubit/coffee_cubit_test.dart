import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/cubit/coffee_cubit.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  late MockCoffeeRepository mockCoffeeRepository;

  setUp(() {
    mockCoffeeRepository = MockCoffeeRepository();
  });

  group('CoffeeCubit', () {
    final coffeeModel = CoffeeModel(imageUrl: 'https://example.com/coffee.jpg');

    setUpAll(() {
      registerFallbackValue(coffeeModel);
    });

    test('initial state is CoffeeInitial', () {
      final cubit = CoffeeCubit(coffeeRepository: mockCoffeeRepository);
      expect(cubit.state, equals(const CoffeeInitial()));
    });

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadSuccess] when fetchCoffee succeeds and coffee is not favorite',
      setUp: () {
        when(
          () => mockCoffeeRepository.fetchCoffee(),
        ).thenAnswer((_) async => Result.ok(coffeeModel));
        when(
          () => mockCoffeeRepository.isCoffeeFavorite(any()),
        ).thenAnswer((_) async => const Ok(false));
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.fetchCoffee(),
      expect: () => <CoffeeState>[
        const CoffeeLoadInProgress(),
        CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.fetchCoffee()).called(1);
        verify(() => mockCoffeeRepository.isCoffeeFavorite(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadSuccess] when fetchCoffee succeeds and coffee is favorite',
      setUp: () {
        when(
          () => mockCoffeeRepository.fetchCoffee(),
        ).thenAnswer((_) async => Result.ok(coffeeModel));
        when(
          () => mockCoffeeRepository.isCoffeeFavorite(any()),
        ).thenAnswer((_) async => const Ok(true));
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.fetchCoffee(),
      expect: () => <CoffeeState>[
        const CoffeeLoadInProgress(),
        CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: true),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.fetchCoffee()).called(1);
        verify(() => mockCoffeeRepository.isCoffeeFavorite(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadSuccess with isFavorite=false] when isCoffeeFavorite fails after fetchCoffee succeeds',
      setUp: () {
        when(
          () => mockCoffeeRepository.fetchCoffee(),
        ).thenAnswer((_) async => Result.ok(coffeeModel));
        when(() => mockCoffeeRepository.isCoffeeFavorite(any())).thenAnswer(
          (_) async =>
              Result.error(const LocalStorageFailure(message: 'local fail')),
        );
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.fetchCoffee(),
      expect: () => <CoffeeState>[
        const CoffeeLoadInProgress(),
        CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.fetchCoffee()).called(1);
        verify(() => mockCoffeeRepository.isCoffeeFavorite(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadFailure] when fetchCoffee fails',
      setUp: () {
        when(() => mockCoffeeRepository.fetchCoffee()).thenAnswer(
          (_) async =>
              Result.error(const NetworkFailure(message: 'Network failure')),
        );
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.fetchCoffee(),
      expect: () => <CoffeeState>[
        const CoffeeLoadInProgress(),
        const CoffeeLoadFailure(
          failure: NetworkFailure(message: 'Network failure'),
        ),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.fetchCoffee()).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits CoffeeAddToFavoritesSuccess when addToFavorites succeeds',
      setUp: () {
        when(
          () => mockCoffeeRepository.addToFavorites(any()),
        ).thenAnswer((_) async => const Ok(null));
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.addToFavorites(coffeeModel),
      expect: () => <CoffeeState>[
        CoffeeAddToFavoritesSuccess(coffee: coffeeModel, isFavorite: true),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.addToFavorites(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits CoffeeAddToFavoritesFailure when addToFavorites fails',
      setUp: () {
        when(() => mockCoffeeRepository.addToFavorites(any())).thenAnswer(
          (_) async =>
              Result.error(const LocalStorageFailure(message: 'fail add')),
        );
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.addToFavorites(coffeeModel),
      expect: () => <CoffeeState>[
        CoffeeAddToFavoritesFailure(coffee: coffeeModel, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.addToFavorites(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits CoffeeRemoveFromFavoritesSuccess when removeFromFavorites succeeds',
      setUp: () {
        when(
          () => mockCoffeeRepository.removeFromFavorites(any()),
        ).thenAnswer((_) async => const Ok(null));
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.removeFromFavorites(coffeeModel),
      expect: () => <CoffeeState>[
        CoffeeRemoveFromFavoritesSuccess(
          coffee: coffeeModel,
          isFavorite: false,
        ),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.removeFromFavorites(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits CoffeeRemoveFromFavoritesFailure when removeFromFavorites fails',
      setUp: () {
        when(() => mockCoffeeRepository.removeFromFavorites(any())).thenAnswer(
          (_) async =>
              Result.error(const LocalStorageFailure(message: 'fail remove')),
        );
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.removeFromFavorites(coffeeModel),
      expect: () => <CoffeeState>[
        CoffeeRemoveFromFavoritesFailure(coffee: coffeeModel, isFavorite: true),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.removeFromFavorites(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'syncIsFavorite emits CoffeeLoadSuccess with updated isFavorite true',
      setUp: () {
        when(
          () => mockCoffeeRepository.isCoffeeFavorite(any()),
        ).thenAnswer((_) async => const Ok(true));
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      seed: () => CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: false),
      act: (cubit) => cubit.syncIsFavorite(),
      expect: () => [CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: true)],
      verify: (_) {
        verify(() => mockCoffeeRepository.isCoffeeFavorite(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'syncIsFavorite emits CoffeeLoadSuccess with updated isFavorite false if not favorite',
      setUp: () {
        when(
          () => mockCoffeeRepository.isCoffeeFavorite(any()),
        ).thenAnswer((_) async => const Ok(false));
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      seed: () => CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: true),
      act: (cubit) => cubit.syncIsFavorite(),
      expect: () => [CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: false)],
      verify: (_) {
        verify(() => mockCoffeeRepository.isCoffeeFavorite(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'syncIsFavorite emits CoffeeLoadSuccess with isFavorite false if repository returns error',
      setUp: () {
        when(() => mockCoffeeRepository.isCoffeeFavorite(any())).thenAnswer(
          (_) async =>
              Result.error(const LocalStorageFailure(message: 'error')),
        );
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      seed: () => CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: true),
      act: (cubit) => cubit.syncIsFavorite(),
      expect: () => [CoffeeLoadSuccess(coffee: coffeeModel, isFavorite: false)],
      verify: (_) {
        verify(() => mockCoffeeRepository.isCoffeeFavorite(any())).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'syncIsFavorite does nothing if state is not CoffeeLoadSuccess',
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.syncIsFavorite(),
      expect: () => <CoffeeState>[],
      verify: (_) {
        verifyNever(() => mockCoffeeRepository.isCoffeeFavorite(any()));
      },
    );
  });
}
