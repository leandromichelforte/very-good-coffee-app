import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/custom_error_widget.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/loading_widget.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/cubit/favorites_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/coffee_card_widget.dart';

class CoffeeTab extends StatelessWidget {
  const CoffeeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<CoffeeCubit, CoffeeState>(
          listener: (context, state) {
            if (state is CoffeeAddToFavoritesSuccess ||
                state is CoffeeRemoveFromFavoritesSuccess) {
              context.read<FavoritesCubit>().loadFavorites();
            } else if (state is CoffeeAddToFavoritesFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Failed to add this coffee to your favorites. Try again later.',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            return BlocBuilder<CoffeeCubit, CoffeeState>(
              builder: (context, state) {
                return switch (state) {
                  CoffeeLoadInProgress() ||
                  CoffeeInitial() => const LoadingWidget(
                    message: 'Your coffee is getting ready...',
                  ),
                  CoffeeLoadFailure() => CustomErrorWidget(
                    message: 'Something went wrong while loading your coffee',
                    onRetry: context.read<CoffeeCubit>().fetchCoffee,
                  ),
                  CoffeeLoadSuccess(:final coffee) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24,
                    children: [
                      Expanded(child: CoffeeCardWidget(coffee: coffee)),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.coffee_rounded),
                              label: Text('New coffee'),
                              onPressed: context
                                  .read<CoffeeCubit>()
                                  .fetchCoffee,
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.favorite_rounded),
                              label: Text(
                                state.isFavorite
                                    ? 'Remove from favorites'
                                    : 'Add to favorites',
                              ),
                              onPressed: () {
                                if (state.isFavorite) {
                                  context
                                      .read<CoffeeCubit>()
                                      .removeFromFavorites(coffee);
                                } else {
                                  context.read<CoffeeCubit>().addToFavorites(
                                    coffee,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                };
              },
            );
          },
        ),
      ),
    );
  }
}
