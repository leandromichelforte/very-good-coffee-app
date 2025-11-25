part of '../favorites_tab.dart';

class _EmptyFavoritesWidget extends StatelessWidget {
  const _EmptyFavoritesWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          Text('Nothing here yet :('),
          Text(
            'Go back to Coffee tab and get your favorite coffees',
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
