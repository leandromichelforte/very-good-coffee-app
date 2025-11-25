import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:very_good_cofee_app/core/injectors/injector.dart';

Future<void> main() async {
  await Injector.inject(GetIt.I);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
