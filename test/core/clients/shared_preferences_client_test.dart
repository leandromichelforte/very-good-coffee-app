import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:very_good_coffee_app/core/clients/shared_preferences_client.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferencesClient', () {
    late SharedPreferencesClient client;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      client = SharedPreferencesClient(
        sharedPreferences: mockSharedPreferences,
      );
    });

    group('writeStringList', () {
      const testKey = 'someKey';
      const testValue = ['a', 'b', 'c'];

      test('should store string list and return true', () async {
        when(
          () => mockSharedPreferences.setStringList(testKey, testValue),
        ).thenAnswer((_) async => true);

        final result = await client.writeStringList(testKey, testValue);

        expect(result, isTrue);
        verify(
          () => mockSharedPreferences.setStringList(testKey, testValue),
        ).called(1);
      });

      test('should return false if setStringList fails', () async {
        when(
          () => mockSharedPreferences.setStringList(testKey, testValue),
        ).thenAnswer((_) async => false);

        final result = await client.writeStringList(testKey, testValue);

        expect(result, isFalse);
        verify(
          () => mockSharedPreferences.setStringList(testKey, testValue),
        ).called(1);
      });
    });

    group('readStringList', () {
      const testKey = 'readKey';
      const storedValue = ['x', 'y'];

      test('should return list if present', () async {
        when(
          () => mockSharedPreferences.getStringList(testKey),
        ).thenReturn(storedValue);

        final result = await client.readStringList(testKey);

        expect(result, equals(storedValue));
        verify(() => mockSharedPreferences.getStringList(testKey)).called(1);
      });

      test('should return empty list if nothing stored', () async {
        when(
          () => mockSharedPreferences.getStringList(testKey),
        ).thenReturn(null);

        final result = await client.readStringList(testKey);

        expect(result, isEmpty);
        verify(() => mockSharedPreferences.getStringList(testKey)).called(1);
      });
    });

    group('remove', () {
      const testKey = 'removeKey';

      test('should remove value and return true', () async {
        when(
          () => mockSharedPreferences.remove(testKey),
        ).thenAnswer((_) async => true);

        final result = await client.remove(testKey);

        expect(result, isTrue);
        verify(() => mockSharedPreferences.remove(testKey)).called(1);
      });

      test('should return false if remove fails', () async {
        when(
          () => mockSharedPreferences.remove(testKey),
        ).thenAnswer((_) async => false);

        final result = await client.remove(testKey);

        expect(result, isFalse);
        verify(() => mockSharedPreferences.remove(testKey)).called(1);
      });
    });
  });
}
