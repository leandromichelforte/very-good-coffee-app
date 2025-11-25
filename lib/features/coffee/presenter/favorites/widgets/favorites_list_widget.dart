part of '../favorites_tab.dart';

class _FavoritesListWidget extends StatelessWidget {
  const _FavoritesListWidget({required this.favorites});

  final List<CoffeeModel> favorites;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final coffee = favorites[index];
        return SizedBox(
          height: 200,
          child: Stack(
            fit: .expand,
            children: [
              CoffeeCardWidget(coffee: coffee),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton.filled(
                  color: Colors.red,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.8),
                  ),
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    context.read<FavoritesCubit>().removeFromFavorites(coffee);
                  },
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16);
      },
      itemCount: favorites.length,
    );
  }
}
