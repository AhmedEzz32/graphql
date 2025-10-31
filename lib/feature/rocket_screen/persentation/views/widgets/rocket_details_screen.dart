import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/core/widgets/error_widget.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/graph_rocket_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_event_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_bloc_state.dart';
import 'package:spacex_information_app/core/helper/rocket_helper.dart';

class RocketDetailsScreen extends StatelessWidget {
  final String rocketId;

  const RocketDetailsScreen({super.key, required this.rocketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<GraphQLRocketBloc, GraphQLRocketState>(
        builder: (context, state) {
          if (state is GraphQLRocketLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GraphQLRocketDetailsLoaded) {
            return RocketHelper().buildRocketDetails(state.rocket, context);
          } else if (state is GraphQLRocketError) {
            return buildErrorWidget(
                state.message,
                context,
                () => context
                    .read<GraphQLRocketBloc>()
                    .add(FetchRocketDetails(rocketId)));
          }
          return const Center(child: Text('Rocket details not available'));
        },
      ),
    );
  }
}
