import 'package:very_good_cofee_app/core/failures/failure.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
///
/// A [Result] is either an [Ok] with a value of type [T]
/// or an [Error] with an [Failure].
///
/// Use [Result.ok] to create a successful result with a value of type [T].
/// Use [Result.error] to create an error result with an [Failure].
sealed class Result<T> {
  const Result();

  /// Creates an instance of [Result] containing a value.
  factory Result.ok(T value) => Ok(value);

  /// Create an instance of [Result] containing an failure.
  factory Result.error(Failure failure) => Error(failure);
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// Returned value in result
  final T value;
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error(this.failure);

  /// Returned error in result
  final Failure failure;
}
