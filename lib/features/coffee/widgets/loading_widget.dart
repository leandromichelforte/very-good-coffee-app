import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisAlignment: .center,
      children: [
        const CircularProgressIndicator.adaptive(),
        Text('Your coffee is getting ready...'),
      ],
    );
  }
}
