import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:very_good_coffee_app/core/injectors/injector.dart';
import 'package:very_good_coffee_app/core/app/app.dart';

final getIt = GetIt.I;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injector.inject(getIt);
  runApp(const App());
}
