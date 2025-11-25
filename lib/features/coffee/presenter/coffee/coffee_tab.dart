import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/custom_error_widget.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/loading_widget.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/cubit/favorites_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/coffee_card_widget.dart';

class CoffeeTab extends StatelessWidget {
  const CoffeeTab({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BlocConsumer<CoffeeCubit, CoffeeState>(
          listener: (context, state) {
            if (state is CoffeeAddToFavoritesSuccess ||
                state is CoffeeRemoveFromFavoritesSuccess) {
              context.read<FavoritesCubit>().loadFavorites();
            } else if (state is CoffeeAddToFavoritesFailure) {
              _showSnackBar(
                context,
                'Failed to add this coffee to your favorites. Try again later.',
              );
            } else if (state is CoffeeRemoveFromFavoritesFailure) {
              _showSnackBar(
                context,
                'Failed to remove this coffee from your favorites. Try again later.',
              );
            }
          },
          buildWhen: (previous, current) {
            return (previous is CoffeeLoadInProgress &&
                    current is CoffeeLoadSuccess) ||
                current is CoffeeAddToFavoritesSuccess ||
                current is CoffeeRemoveFromFavoritesSuccess ||
                current is CoffeeLoadInProgress;
          },
          builder: (context, state) {
            return switch (state) {
              CoffeeLoadInProgress() || CoffeeInitial() => const LoadingWidget(
                message: 'Your coffee is getting ready...',
              ),
              CoffeeLoadFailure() => CustomErrorWidget(
                message: 'Something went wrong while loading your coffee',
                onRetry: context.read<CoffeeCubit>().fetchCoffee,
              ),
              CoffeeLoadSuccess(:final coffee, :final isFavorite) =>
                _CoffeeLoadSuccessWidget(
                  coffee: coffee,
                  isFavorite: isFavorite,
                ),
            };
          },
        ),
      ),
    );
  }
}

class _CoffeeLoadSuccessWidget extends StatelessWidget {
  const _CoffeeLoadSuccessWidget({
    required this.coffee,
    required this.isFavorite,
  });

  final CoffeeModel coffee;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                label: Text('New coffee', textAlign: .center),
                onPressed: context.read<CoffeeCubit>().fetchCoffee,
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  isFavorite ? Icons.delete_rounded : Icons.favorite_rounded,
                ),
                label: Text(
                  isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  textAlign: .center,
                ),
                onPressed: () {
                  final coffeeCubit = context.read<CoffeeCubit>();
                  if (isFavorite) {
                    coffeeCubit.removeFromFavorites(coffee);
                  } else {
                    coffeeCubit.addToFavorites(coffee);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
