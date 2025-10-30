import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/map_screen/presentation/view_models/map_bloc.dart';
import 'package:spacex_information_app/feature/map_screen/presentation/view_models/map_event.dart';

class SpaceMapBodyWidget extends StatelessWidget {
  final String? message;

  const SpaceMapBodyWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'An error occurred',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<MapBloc>().add(const LoadMapData());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
