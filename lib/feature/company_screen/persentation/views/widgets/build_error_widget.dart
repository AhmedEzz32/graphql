import 'package:flutter/material.dart';

Widget buildErrorWidget(
    BuildContext context, String message, VoidCallback onPressed) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          size: 64,
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        Text(
          'Error',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => onPressed,
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
