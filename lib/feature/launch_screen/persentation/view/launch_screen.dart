import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/core/helper/rocket_helper.dart';
import 'package:spacex_information_app/core/widgets/error_widget.dart';
import 'package:spacex_information_app/feature/launch_screen/data/graph_launch_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/data/launch_event_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/data/launch_state_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view/widgets/build_launch_filter_section.dart';
import '../view_model/graphql_launch_models.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = context.read<GraphQLLaunchBloc>().state;
    if (currentState is GraphQLLaunchInitial) {
      context.read<GraphQLLaunchBloc>().add(const FetchLaunches());
    }

    return Scaffold(
      body: BlocBuilder<GraphQLLaunchBloc, GraphQLLaunchState>(
          builder: (context, state) {
        return Column(
          children: [
            BlocBuilder<GraphQLLaunchBloc, GraphQLLaunchState>(
              builder: (context, state) =>
                  buildLaunchFilterSection(context, state),
            ),
            Expanded(
              child: () {
                if (state is GraphQLLaunchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GraphQLLaunchesLoaded) {
                  return _buildLaunchList(state.launches);
                } else if (state is GraphQLLaunchError) {
                  return buildErrorWidget(
                      state.message,
                      context,
                      () => context
                          .read<GraphQLLaunchBloc>()
                          .add(const FetchLaunches()));
                }
                return const Center(child: Text('Welcome to SpaceX Launches!'));
              }(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLaunchList(List<GraphQLLaunch> launches) {
    if (launches.isEmpty) {
      return const Center(
        child: Text(
          'No launches found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: launches.length,
      itemBuilder: (context, index) {
        return RocketHelper().buildLaunchCard(launches[index]);
      },
    );
  }
}
