import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_cofee_app/core/constants/strings_constants.dart';
import 'package:very_good_cofee_app/core/themes/app_theme.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/coffee_tab.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/cubit/favorites_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/favorites_tab.dart';
import 'package:very_good_cofee_app/main.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringsConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
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
        child: const _HomeScreen(),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringsConstants.appTitle),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.coffee_rounded), text: 'Coffee'),
              Tab(icon: Icon(Icons.favorite_rounded), text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(children: [CoffeeTab(), FavoritesTab()]),
      ),
    );
  }
}
