import 'package:flutter/material.dart';
import 'package:very_good_cofee_app/core/clients/main_http_client.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final result = await CoffeeRemoteDataSource(
                mainHttpClient: MainHttpClient(),
              ).fetchCoffee();

              print(result);
            },
            child: Text('data'),
          ),
        ),
      ),
    );
  }
}
