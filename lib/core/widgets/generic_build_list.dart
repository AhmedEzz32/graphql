import 'package:flutter/material.dart';

class GenericBuildList<T> extends StatelessWidget {
  final List<T> data;
  final Widget Function(BuildContext context, T item) itemBuilder;

  const GenericBuildList({
    super.key,
    required this.data,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return itemBuilder(context, item);
      },
    );
  }
}
