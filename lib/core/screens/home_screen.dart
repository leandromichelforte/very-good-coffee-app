import 'package:flutter/material.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/coffee_tab.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/favorites_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.coffee_rounded), text: 'Coffee'),
              Tab(icon: Icon(Icons.favorite_rounded), text: 'Favorites'),
            ],
          ),
        ),
        body: Column(
          children: [
            const Expanded(
              child: TabBarView(children: [CoffeeTab(), FavoritesTab()]),
            ),
          ],
        ),
      ),
    );
  }
}
