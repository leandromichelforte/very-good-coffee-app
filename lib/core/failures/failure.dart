import 'package:equatable/equatable.dart';

/// Base class representing a failure in the application.
///
/// Contains a [message] describing the failure.
sealed class Failure extends Equatable {
  const Failure({required this.message});

  /// Description of the failure.
  final String message;

  @override
  List<Object> get props => [message];
}

/// Represents a failure caused by network issues.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Represents a failure that occurs during operations involving shared preferences.
class LocalStorageFailure extends Failure {
  const LocalStorageFailure({required super.message});
}

/// Represents an unknown or unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
