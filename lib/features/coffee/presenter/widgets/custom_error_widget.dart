import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    required this.message,
    VoidCallback? onRetry,
    super.key,
  }) : _onRetry = onRetry;

  final String message;
  final VoidCallback? _onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisAlignment: .center,
      children: [
        const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
        Text(message, textAlign: .center),
        if (_onRetry != null) ...[
          ElevatedButton.icon(
            icon: Icon(Icons.refresh_rounded),
            label: Text('Retry'),
            onPressed: _onRetry,
          ),
        ],
      ],
    );
  }
}
