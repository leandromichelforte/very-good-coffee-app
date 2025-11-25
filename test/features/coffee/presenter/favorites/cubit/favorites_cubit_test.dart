import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/cubit/favorites_cubit.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  late MockCoffeeRepository mockCoffeeRepository;
  late FavoritesCubit favoritesCubit;

  final coffeeModel1 = CoffeeModel(imageUrl: 'https://example.com/coffee1.jpg');
  final coffeeModel2 = CoffeeModel(imageUrl: 'https://example.com/coffee2.jpg');
  final favoritesList = [coffeeModel1, coffeeModel2];

  setUpAll(() {
    registerFallbackValue(coffeeModel1);
  });

  setUp(() {
    mockCoffeeRepository = MockCoffeeRepository();
    favoritesCubit = FavoritesCubit(coffeeRepository: mockCoffeeRepository);
  });

  tearDown(() {
    favoritesCubit.close();
  });

  group('FavoritesCubit', () {
    test('initial state is FavoritesInitial', () {
      expect(favoritesCubit.state, equals(const FavoritesInitial()));
    });

    blocTest<FavoritesCubit, FavoritesState>(
      'emits [FavoritesLoadInProgress, FavoritesLoadSuccess] when loadFavorites succeeds',
      setUp: () {
        when(
          () => mockCoffeeRepository.getFavorites(),
        ).thenAnswer((_) async => Ok<List<CoffeeModel>>(favoritesList));
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.loadFavorites(),
      expect: () => <FavoritesState>[
        const FavoritesLoadInProgress(),
        FavoritesLoadSuccess(favorites: favoritesList),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.getFavorites()).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emits [FavoritesLoadInProgress, FavoritesLoadFailure] when loadFavorites fails',
      setUp: () {
        when(() => mockCoffeeRepository.getFavorites()).thenAnswer(
          (_) async => Error<List<CoffeeModel>>(
            const LocalStorageFailure(message: 'fail'),
          ),
        );
      },
      build: () => favoritesCubit,
      act: (cubit) => cubit.loadFavorites(),
      expect: () => <FavoritesState>[
        const FavoritesLoadInProgress(),
        FavoritesLoadFailure(
          failure: const LocalStorageFailure(message: 'fail'),
        ),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.getFavorites()).called(1);
      },
    );

    group('removeFromFavorites', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'emits [RemoveFromFavoritesSuccess, FavoritesLoadInProgress, FavoritesLoadSuccess] '
        'when removeFromFavorites succeeds',
        setUp: () {
          when(
            () => mockCoffeeRepository.removeFromFavorites(any()),
          ).thenAnswer((_) async => const Ok(null));
          when(
            () => mockCoffeeRepository.getFavorites(),
          ).thenAnswer((_) async => Ok<List<CoffeeModel>>([coffeeModel2]));
        },
        build: () => favoritesCubit,
        seed: () => FavoritesLoadSuccess(favorites: favoritesList),
        act: (cubit) => cubit.removeFromFavorites(coffeeModel1),
        expect: () => [
          RemoveFromFavoritesSuccess(favorites: favoritesList),
          const FavoritesLoadInProgress(),
          FavoritesLoadSuccess(favorites: [coffeeModel2]),
        ],
        verify: (_) {
          verify(
            () => mockCoffeeRepository.removeFromFavorites(coffeeModel1),
          ).called(1);
          verify(() => mockCoffeeRepository.getFavorites()).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [RemoveFromFavoritesFailure] when removeFromFavorites fails',
        setUp: () {
          when(
            () => mockCoffeeRepository.removeFromFavorites(any()),
          ).thenAnswer(
            (_) async =>
                Error<void>(const LocalStorageFailure(message: 'fail remove')),
          );
        },
        build: () => favoritesCubit,
        seed: () => FavoritesLoadSuccess(favorites: favoritesList),
        act: (cubit) => cubit.removeFromFavorites(coffeeModel1),
        expect: () => [RemoveFromFavoritesFailure(favorites: favoritesList)],
        verify: (_) {
          verify(
            () => mockCoffeeRepository.removeFromFavorites(coffeeModel1),
          ).called(1);
        },
      );
    });
  });
}
