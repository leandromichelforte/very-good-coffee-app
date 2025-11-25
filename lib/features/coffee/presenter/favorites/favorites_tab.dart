import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/cubit/coffee_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/coffee_card_widget.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/loading_widget.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/favorites/cubit/favorites_cubit.dart';

part './widgets/empty_favorites_widget.dart';
part './widgets/favorites_list_widget.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesState>(
      listener: (context, state) {
        if (state is RemoveFromFavoritesSuccess) {
          context.read<CoffeeCubit>().syncIsFavorite();
        } else if (state is RemoveFromFavoritesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Something went wrong while removing the coffee from favorites. Try again later.',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      buildWhen: (_, current) {
        return current is! RemoveFromFavoritesFailure &&
            current is! RemoveFromFavoritesLoadInProgress;
      },
      builder: (context, state) {
        if (state is FavoritesLoadSuccess) {
          if (state.favorites.isEmpty) {
            return const _EmptyFavoritesWidget();
          }

          return _FavoritesListWidget(favorites: state.favorites);
        }

        return const LoadingWidget(message: 'Loading your favorite coffees...');
      },
    );
  }
}
