import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Model representing a coffee with it's [imageUrl].
class CoffeeModel extends Equatable {
  final String imageUrl;

  const CoffeeModel({required this.imageUrl});

  /// Creates a [CoffeeModel] from a JSON.
  factory CoffeeModel.fromJson(String json) {
    final decodedJson = jsonDecode(json);
    final imageUrl = decodedJson['file'] as String;

    return CoffeeModel(imageUrl: imageUrl);
  }

  /// Converts this [CoffeeModel] instance to a JSON string representation.
  String toJson() {
    final map = {'file': imageUrl};
    return jsonEncode(map);
  }

  @override
  List<Object> get props => [imageUrl];
}
