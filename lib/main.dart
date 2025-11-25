import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:very_good_cofee_app/core/constants/strings_constants.dart';
import 'package:very_good_cofee_app/core/injectors/injector.dart';
import 'package:very_good_cofee_app/core/screens/home_screen.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/cubit/favorites_cubit.dart';

final getIt = GetIt.I;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                CoffeeCubit(coffeeRepository: getIt.get<CoffeeRepository>())
                  ..fetchCoffee(),
          ),
          BlocProvider(
            create: (context) =>
                FavoritesCubit(coffeeRepository: getIt.get<CoffeeRepository>())
                  ..loadFavorites(),
          ),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
