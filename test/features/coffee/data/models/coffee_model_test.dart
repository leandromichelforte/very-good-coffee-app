import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';

void main() {
  group('CoffeeModel', () {
    const testImageUrl = 'https://example.com/coffee.jpg';

    group('fromJson', () {
      test('should create a CoffeeModel from a valid JSON string', () {
        final jsonString = jsonEncode({'file': testImageUrl});

        final model = CoffeeModel.fromJson(jsonString);

        expect(model.imageUrl, equals(testImageUrl));
      });
    });
    group('toJson', () {
      test('should convert CoffeeModel to a valid JSON string', () {
        const model = CoffeeModel(imageUrl: testImageUrl);

        final jsonString = model.toJson();

        expect(jsonString, equals(jsonEncode({'file': testImageUrl})));
      });
    });

    group('equality', () {
      test('should be equal when imageUrls are the same', () {
        const model1 = CoffeeModel(imageUrl: testImageUrl);
        const model2 = CoffeeModel(imageUrl: testImageUrl);

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('should not be equal when imageUrls are different', () {
        const model1 = CoffeeModel(imageUrl: testImageUrl);
        const model2 = CoffeeModel(
          imageUrl: 'https://example.com/different.jpg',
        );

        expect(model1, isNot(equals(model2)));
      });
    });

    group('props', () {
      test('should return imageUrl in props list', () {
        final props = CoffeeModel(imageUrl: testImageUrl).props;

        expect(props, equals([testImageUrl]));
      });
    });
  });
}
