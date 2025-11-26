import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_app/core/results/result.dart';
import 'package:very_good_coffee_app/core/failures/failure.dart';

void main() {
  group('Result', () {
    group('Ok', () {
      test('should create an Ok result with the given value', () {
        const value = 'test-value';
        final result = Result.ok(value);

        expect(result, isA<Ok<String>>());
        expect((result as Ok<String>).value, equals(value));
      });
    });

    group('Error', () {
      test('should create an Error result with the given failure', () {
        const failure = NetworkFailure(message: 'Network error!');
        final result = Result<String>.error(failure);

        expect(result, isA<Error<String>>());
        expect((result as Error<String>).failure, equals(failure));
      });

      test('Error of UnknownFailure should store the correct failure', () {
        const failure = UnknownFailure(message: 'Unknown error');
        final result = Result<int>.error(failure);

        expect(result, isA<Error<int>>());
        expect((result as Error<int>).failure, equals(failure));
      });
    });
  });
}
