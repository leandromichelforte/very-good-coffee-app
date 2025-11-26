import 'package:shared_preferences/shared_preferences.dart';

/// A thin wrapper around [SharedPreferences] for basic key-value storage.
class SharedPreferencesClient {
  /// Creates a [SharedPreferencesClient] with the given [sharedPreferences] instance.
  const SharedPreferencesClient({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Stores a list of strings [value] under the given [key].
  Future<bool> writeStringList(String key, List<String> value) {
    return _sharedPreferences.setStringList(key, value);
  }

  /// Retrieves the list of strings stored under [key].
  Future<List<String>> readStringList(String key) async {
    return _sharedPreferences.getStringList(key) ?? [];
  }

  /// Removes the value stored under [key].
  Future<bool> remove(String key) => _sharedPreferences.remove(key);
}
