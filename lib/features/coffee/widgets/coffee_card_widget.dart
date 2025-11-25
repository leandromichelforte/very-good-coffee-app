import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/custom_error_widget.dart';
import 'package:very_good_cofee_app/features/coffee/widgets/loading_widget.dart';

class CoffeeCardWidget extends StatelessWidget {
  const CoffeeCardWidget({super.key, required this.coffee});

  final CoffeeModel coffee;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: coffee.imageUrl,
        placeholder: (_, _) =>
            const LoadingWidget(message: 'Your coffee is getting ready...'),
        errorWidget: (_, _, _) {
          return CustomErrorWidget(
            message: 'Something went wrong while loading your coffee',
          );
        },
      ),
    );
  }
}
