import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_event_bloc.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_error_widget.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_bloc_state.dart';
import '../view_model/graphql_launch_models.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool? _successFilter;
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
          _buildQuickFilters(),
          Expanded(
            child: BlocBuilder<GraphQLLaunchBloc, GraphQLLaunchState>(
              builder: (context, state) {
                if (state is GraphQLLaunchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GraphQLLaunchesLoaded) {
                  return _buildLaunchList(state.launches);
                } else if (state is GraphQLLaunchError) {
                  return buildErrorWidget(context, state.message, () {
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
                    launch.upcoming
                        ? 'Upcoming'
                        : launch.success == true
                            ? 'Success'
                            : launch.success == false
                                ? 'Failed'
                                : 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Flight #${launch.flightNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'No Name',
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
              'Date: ${_formatDate(launch.dateUtc!)}',
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
                  label: const Text('Successful'),
                  selected: _successFilter == true,
                  onSelected: (selected) {
                    setState(() {
                      _successFilter = selected ? true : null;
                    });
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterChip(
                  label: const Text('Failed'),
                  selected: _successFilter == false,
                  onSelected: (selected) {
                    setState(() {
                      _successFilter = selected ? false : null;
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
                    _successFilter = null;
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

  Widget _buildQuickFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<GraphQLLaunchBloc>()
                    .add(const FetchUpcomingLaunches());
                setState(() {
                  _searchController.clear();
                  _successFilter = null;
                  _upcomingFilter = null;
                });
              },
              child: const Text('Upcoming'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<GraphQLLaunchBloc>()
                    .add(const FetchPastLaunches());
                setState(() {
                  _searchController.clear();
                  _successFilter = null;
                  _upcomingFilter = null;
                });
              },
              child: const Text('Past'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<GraphQLLaunchBloc>().add(const FetchLaunches());
                setState(() {
                  _searchController.clear();
                  _successFilter = null;
                  _upcomingFilter = null;
                });
              },
              child: const Text('All'),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    context.read<GraphQLLaunchBloc>().add(FilterLaunches(
          launchSuccess: _successFilter,
        ));
  }
}
