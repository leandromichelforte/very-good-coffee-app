import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/coffee_cubit.dart';
import 'package:very_good_cofee_app/features/coffee/presenter/coffee/coffee_state.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/custom_error_widget.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/loading_widget.dart';

class CoffeeTab extends StatelessWidget {
  const CoffeeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<CoffeeCubit, CoffeeState>(
          builder: (context, state) {
            return switch (state) {
              CoffeeLoadInProgress() ||
              CoffeeInitial() => const LoadingWidget(),
              CoffeeLoadFailure() => CustomErrorWidget(
                message: 'Something went wrong while loading your coffee',
                onRetry: context.read<CoffeeCubit>().fetchCoffee,
              ),
              CoffeeLoadSuccess(:final coffee) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: coffee.imageUrl,
                      placeholder: (_, _) => const LoadingWidget(),
                      errorWidget: (_, _, _) {
                        return CustomErrorWidget(
                          message:
                              'Something went wrong while loading your coffee',
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.coffee_rounded),
                    label: Text('New Coffee'),
                    onPressed: context.read<CoffeeCubit>().fetchCoffee,
                  ),
                ],
              ),
            };
          },
        ),
      ),
    );
  }
}
