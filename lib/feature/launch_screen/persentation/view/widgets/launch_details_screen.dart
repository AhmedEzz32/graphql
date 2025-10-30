import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/core/widgets/error_widget.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_event_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view/widgets/build_launch_details_card_widget.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_bloc_state.dart';

class LaunchDetailsScreen extends StatefulWidget {
  final String launchId;

  const LaunchDetailsScreen({super.key, required this.launchId});

  @override
  State<LaunchDetailsScreen> createState() => _LaunchDetailsScreenState();
}

class _LaunchDetailsScreenState extends State<LaunchDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GraphQLLaunchBloc>().add(FetchLaunchDetails(widget.launchId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launch Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<GraphQLLaunchBloc, GraphQLLaunchState>(
        builder: (context, state) {
          if (state is GraphQLLaunchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GraphQLLaunchDetailsLoaded) {
            return buildGraphQLLaunchDetailsCard(context, state.launch,
                DateTime.parse(state.launch.launchDateUtc!));
          } else if (state is GraphQLLaunchError) {
            return buildErrorWidget(state.message, context, () {
              context
                  .read<GraphQLLaunchBloc>()
                  .add(FetchLaunchDetails(widget.launchId));
            });
          }
          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
