import 'package:equatable/equatable.dart';
import 'package:very_good_cofee_app/core/failures/failure.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';

sealed class CoffeeState extends Equatable {
  const CoffeeState();

  @override
  List<Object> get props => [];
}

final class CoffeeInitial extends CoffeeState {
  const CoffeeInitial();
}

final class CoffeeLoadInProgress extends CoffeeState {
  const CoffeeLoadInProgress();
}

final class CoffeeLoadSuccess extends CoffeeState {
  const CoffeeLoadSuccess({required this.coffee});

  final CoffeeModel coffee;

  @override
  List<Object> get props => [coffee];
}

final class CoffeeLoadFailure extends CoffeeState {
  const CoffeeLoadFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
