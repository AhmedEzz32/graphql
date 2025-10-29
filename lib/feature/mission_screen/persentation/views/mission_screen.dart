import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_event_bloc.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_error_widget.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_bloc_state.dart';
import '../../../launch_screen/persentation/view_model/graphql_launch_models.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool? _reusedFilter;

  @override
  void initState() {
    super.initState();
    context.read<GraphQLLaunchBloc>().add(const FetchLaunches());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: BlocBuilder<GraphQLLaunchBloc, GraphQLLaunchState>(
              builder: (context, state) {
                if (state is GraphQLLaunchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GraphQLLaunchesLoaded) {
                  return _buildMissionList(state.launches);
                } else if (state is GraphQLLaunchError) {
                  return buildErrorWidget(context, state.message, () {
                    context
                        .read<GraphQLLaunchBloc>()
                        .add(const FetchLaunches());
                  });
                }
                return const Center(child: Text('Welcome to SpaceX Missions!'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GraphQLLaunchBloc>().add(const RefreshLaunches());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildMissionList(List<GraphQLLaunch> launches) {
    List<GraphQLLaunchPayload> allPayloads = [];
    for (var launch in launches) {
      if (launch.rocket.secondStage?.payloads != null) {
        allPayloads.addAll(launch.rocket.secondStage!.payloads);
      }
    }

    if (allPayloads.isEmpty) {
      return const Center(
        child: Text(
          'No missions found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allPayloads.length,
      itemBuilder: (context, index) {
        return _buildMissionCard(
            allPayloads[index], launches[index % launches.length]);
      },
    );
  }

  Widget _buildMissionCard(GraphQLLaunchPayload payload, GraphQLLaunch launch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: payload.reused == true ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    payload.reused == true ? 'REUSED' : 'NEW',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  payload.payloadType.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              payload.payloadId,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 4),
            Text(
              'Orbit: ${payload.orbit}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            if (payload.payloadMassKg != null) ...[
              const SizedBox(height: 4),
              Text(
                'Mass: ${payload.payloadMassKg!.toStringAsFixed(0)} kg',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Customers: ${payload.customers.join(', ')}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manufacturer: ${payload.manufacturer}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Nationality: ${payload.nationality}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search missions/payloads...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => _applyFilters(),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Reused'),
                  selected: _reusedFilter == true,
                  onSelected: (selected) {
                    setState(() {
                      _reusedFilter = selected ? true : null;
                    });
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('New'),
                  selected: _reusedFilter == false,
                  onSelected: (selected) {
                    setState(() {
                      _reusedFilter = selected ? false : null;
                    });
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _reusedFilter = null;
                    });
                    context
                        .read<GraphQLLaunchBloc>()
                        .add(const FetchLaunches());
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // For missions/payloads, we'll just refresh the launch data
    // since GraphQL API doesn't have specific payload filtering
    context.read<GraphQLLaunchBloc>().add(const FetchLaunches());
  }
}
