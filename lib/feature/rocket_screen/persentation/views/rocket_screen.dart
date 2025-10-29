import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/data/rocket_event_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/data/rocket_bloc_state.dart';
import '../views_model/graphql_rocket_models.dart';
import 'widgets/rocket_details_screen.dart';

class RocketScreen extends StatefulWidget {
  const RocketScreen({super.key});

  @override
  State<RocketScreen> createState() => _RocketScreenState();
}

class _RocketScreenState extends State<RocketScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    context.read<GraphQLRocketBloc>().add(const FetchRockets());
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
            child: BlocBuilder<GraphQLRocketBloc, GraphQLRocketState>(
              builder: (context, state) {
                if (state is GraphQLRocketLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GraphQLRocketsLoaded) {
                  return _buildRocketList(state.rockets);
                } else if (state is GraphQLRocketError) {
                  return _buildErrorWidget(state.message);
                }
                return const Center(child: Text('Welcome to SpaceX Rockets!'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GraphQLRocketBloc>().add(const RefreshRockets());
        },
        child: const Icon(Icons.refresh),
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
              hintText: 'Search rockets...',
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
                  label: const Text('Active Only'),
                  selected: _activeFilter == true,
                  selectedColor: Colors.green.withOpacity(0.2),
                  checkmarkColor: Colors.green,
                  onSelected: (selected) {
                    setState(() {
                      _activeFilter = selected ? true : null;
                    });
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterChip(
                  label: const Text('Inactive Only'),
                  selected: _activeFilter == false,
                  selectedColor: Colors.red.withOpacity(0.2),
                  checkmarkColor: Colors.red,
                  onSelected: (selected) {
                    setState(() {
                      _activeFilter = selected ? false : null;
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
                    _activeFilter = null;
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
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      context.read<GraphQLRocketBloc>().add(SearchRockets(searchQuery));
    } else {
      context.read<GraphQLRocketBloc>().add(const FetchRockets());
    }
  }

  List<GraphQLRocket> _applyActiveFilter(List<GraphQLRocket> rockets) {
    if (_activeFilter == null) {
      return rockets;
    }
    return rockets.where((rocket) => rocket.active == _activeFilter).toList();
  }

  Widget _buildRocketList(List<GraphQLRocket> rockets) {
    final filteredRockets = _applyActiveFilter(rockets);

    if (filteredRockets.isEmpty) {
      return Center(
        child: Text(
          _activeFilter == null
              ? 'No Rocket found'
              : 'No ${_activeFilter! ? 'Active' : 'Inactive'} rockets found',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredRockets.length,
      itemBuilder: (context, index) {
        final rocket = filteredRockets[index];
        return _buildRocketCard(rocket);
      },
    );
  }

  Widget _buildRocketCard(GraphQLRocket rocket) {
    final numberFormat = NumberFormat('#,###');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RocketDetailsScreen(rocketId: rocket.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rocket.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rocket.type,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: rocket.active ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      rocket.active ? 'Active' : 'Inactive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (rocket.country.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: rocket.country[0],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                rocket.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      'Height',
                      '${rocket.height.meters?.toStringAsFixed(1) ?? 'N/A'} m',
                      Icons.height,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoChip(
                      'Mass',
                      '${rocket.mass.kg != null ? numberFormat.format(rocket.mass.kg!) : 'N/A'} kg',
                      Icons.fitness_center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      'Cost',
                      '\$${numberFormat.format(rocket.costPerLaunch)}',
                      Icons.attach_money,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoChip(
                      'Success Rate',
                      '${rocket.successRatePct}%',
                      Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
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
            onPressed: () {
              context.read<GraphQLRocketBloc>().add(const FetchRockets());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
