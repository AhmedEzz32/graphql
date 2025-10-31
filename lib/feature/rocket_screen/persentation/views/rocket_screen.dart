import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/core/helper/rocket_helper.dart';
import 'package:spacex_information_app/core/widgets/error_widget.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/graph_rocket_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_event_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_bloc_state.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views/widgets/build_section_filter.dart';

class RocketScreen extends StatelessWidget {
  const RocketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = context.read<GraphQLRocketBloc>().state;
    if (currentState is GraphQLRocketInitial) {
      context.read<GraphQLRocketBloc>().add(const FetchRockets());
    }

    return Scaffold(
      body: BlocBuilder<GraphQLRocketBloc, GraphQLRocketState>(
          builder: (context, state) {
        return Column(
          children: [
            buildFilterSection(context, state),
            Expanded(
              child: () {
                if (state is GraphQLRocketLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GraphQLRocketsLoaded) {
                  return RocketHelper().buildRocketList(state.rockets);
                } else if (state is GraphQLRocketError) {
                  return buildErrorWidget(state.message, context, () {
                    context.read<GraphQLRocketBloc>().add(const FetchRockets());
                  });
                }
                return const Center(child: Text('Welcome to SpaceX Rockets!'));
              }(),
            ),
          ],
        );
      }),
    );
  }
}
