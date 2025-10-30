import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/core/widgets/error_widget.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_event_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_bloc_state.dart';
import '../view_model/graphql_launch_models.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool? _pastFilter;
  bool? _upcomingFilter;

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
                  return _buildLaunchList(state.launches);
                } else if (state is GraphQLLaunchError) {
                  return buildErrorWidget(state.message, context, () {
                    context
                        .read<GraphQLLaunchBloc>()
                        .add(const FetchLaunches());
                  });
                }
                return const Center(child: Text('Welcome to SpaceX Launches!'));
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
        return _buildLaunchCard(launches[index]);
      },
    );
  }

  Widget _buildLaunchCard(GraphQLLaunch launch) {
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
                    color: launch.success == true
                        ? Colors.green
                        : launch.success == false
                            ? Colors.red
                            : Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    launch.upcoming == true ? 'Upcoming' : 'Past',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // const Spacer(),
                // Text(
                //   'Flight #${launch.flightNumber}',
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              launch.missionName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Rocket: ${launch.rocket.name}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${_formatDate(launch.launchDateUtc)}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            if (launch.details != null) ...[
              const SizedBox(height: 8),
              Text(
                launch.details!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'TBD';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search launches...',
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
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: const Text('Past'),
                  selected: _pastFilter == true,
                  onSelected: (selected) {
                    setState(() {
                      _pastFilter = selected ? true : null;
                      if (selected) {
                        _upcomingFilter = null;
                      }
                    });
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterChip(
                  label: const Text('Upcoming'),
                  selected: _upcomingFilter == true,
                  onSelected: (selected) {
                    setState(() {
                      _upcomingFilter = selected ? true : null;
                      if (selected) {
                        _pastFilter = null;
                      }
                    });
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _pastFilter = null;
                    _upcomingFilter = null;
                  });
                  _applyFilters();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    context.read<GraphQLLaunchBloc>().add(FilterLaunches(
          searchQuery:
              _searchController.text.isNotEmpty ? _searchController.text : null,
          showPast: _pastFilter,
          showUpcoming: _upcomingFilter,
        ));
  }
}
