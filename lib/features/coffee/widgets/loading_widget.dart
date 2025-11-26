import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisAlignment: .center,
      children: [
        const CircularProgressIndicator.adaptive(),
        Text(message),
      ],
    );
  }
}
