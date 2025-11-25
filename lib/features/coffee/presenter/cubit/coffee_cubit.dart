import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';

part 'coffee_state.dart';

/// A Cubit responsible for managing and emitting states related to fetching coffee data.
class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit({required CoffeeRepository coffeeRepository})
    : _coffeeRepository = coffeeRepository,
      super(const CoffeeInitial());

  final CoffeeRepository _coffeeRepository;

  /// Fetches coffee data from the repository and emits corresponding states
  /// based on the operation result (loading, success, or failure).
  void fetchCoffee() async {
    emit(const CoffeeLoadInProgress());

    final result = await _coffeeRepository.fetchCoffee();

    switch (result) {
      case Ok<CoffeeModel>():
        emit(CoffeeLoadSuccess(coffee: result.value));
        break;
      case Error():
        emit(CoffeeLoadFailure(failure: result.failure));
        break;
    }
  }
}
