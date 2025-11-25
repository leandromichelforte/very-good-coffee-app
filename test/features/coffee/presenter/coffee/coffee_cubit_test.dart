import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/coffee_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/coffee_state.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  late MockCoffeeRepository mockCoffeeRepository;

  setUp(() {
    mockCoffeeRepository = MockCoffeeRepository();
  });

  group('CoffeeCubit', () {
    final coffeeModel = CoffeeModel(imageUrl: 'https://example.com/coffee.jpg');

    test('initial state is CoffeeInitial', () {
      final cubit = CoffeeCubit(coffeeRepository: mockCoffeeRepository);
      expect(cubit.state, equals(const CoffeeInitial()));
    });

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadSuccess] when fetchCoffee succeeds',
      setUp: () {
        when(
          () => mockCoffeeRepository.fetchCoffee(),
        ).thenAnswer((_) async => Result.ok(coffeeModel));
      },
      build: () => CoffeeCubit(coffeeRepository: mockCoffeeRepository),
      act: (cubit) => cubit.fetchCoffee(),
      expect: () => <CoffeeState>[
        const CoffeeLoadInProgress(),
        CoffeeLoadSuccess(coffee: coffeeModel),
      ],
      verify: (_) {
        verify(() => mockCoffeeRepository.fetchCoffee()).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadFailure] when fetchCoffee fails',
      setUp: () {
        when(() => mockCoffeeRepository.fetchCoffee()).thenAnswer(
          (_) async => Result.error(NetworkFailure(message: 'Network failure')),
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
  });
}
