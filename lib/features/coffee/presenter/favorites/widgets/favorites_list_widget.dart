part of '../favorites_tab.dart';

class _FavoritesListWidget extends StatelessWidget {
  const _FavoritesListWidget({required this.favorites});

  final List<CoffeeModel> favorites;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              final coffee = favorites[index];

              return SizedBox(
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
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
                        icon: const Icon(Icons.delete_rounded),
                        onPressed: () {
                          context.read<FavoritesCubit>().removeFromFavorites(
                            coffee,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, index) => const SizedBox(height: 16),
            itemCount: favorites.length,
          ),
        ),
      ],
    );
  }
}
