import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:very_good_cofee_app/core/constants/strings_constants.dart';
import 'package:very_good_cofee_app/core/injectors/injector.dart';
import 'package:very_good_cofee_app/core/screens/home_screen.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/coffee_cubit.dart';

final getIt = GetIt.I;

Future<void> main() async {
  await Injector.inject(getIt);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringsConstants.appTitle,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) =>
            CoffeeCubit(coffeeRepository: getIt.get<CoffeeRepository>())
              ..fetchCoffee(),
        child: HomeScreen(),
      ),
    );
  }
}
