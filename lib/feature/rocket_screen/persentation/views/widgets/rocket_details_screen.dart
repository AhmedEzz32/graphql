import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/data/rocket_event_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/data/rocket_bloc_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../views_model/graphql_rocket_models.dart';

class RocketDetailsScreen extends StatefulWidget {
  final String rocketId;

  const RocketDetailsScreen({super.key, required this.rocketId});

  @override
  State<RocketDetailsScreen> createState() => _RocketDetailsScreenState();
}

class _RocketDetailsScreenState extends State<RocketDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GraphQLRocketBloc>().add(FetchRocketDetails(widget.rocketId));
  }

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
            return _buildRocketDetails(state.rocket);
          } else if (state is GraphQLRocketError) {
            return _buildErrorWidget(state.message);
          }
          return const Center(child: Text('Rocket details not available'));
        },
      ),
    );
  }

  Widget _buildRocketDetails(GraphQLRocket rocket) {
    final numberFormat = NumberFormat('#,###');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rocket.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rocket.type,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: rocket.active ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  rocket.active ? 'Active' : 'Inactive',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Images gallery
          if (rocket.country.isNotEmpty) ...[
            Text(
              'Gallery',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: rocket.country.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: rocket.country[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            rocket.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Specifications
          Text(
            'Specifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildSpecsGrid(rocket, numberFormat),
          const SizedBox(height: 24),

          // Company and Country
          Text(
            'Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildDetailsCard(rocket),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSpecsGrid(GraphQLRocket rocket, NumberFormat numberFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSpecRow('Height',
                '${rocket.height.meters?.toStringAsFixed(1) ?? 'N/A'} m (${rocket.height.feet?.toStringAsFixed(1) ?? 'N/A'} ft)'),
            const Divider(),
            _buildSpecRow('Diameter',
                '${rocket.diameter.meters?.toStringAsFixed(1) ?? 'N/A'} m (${rocket.diameter.feet?.toStringAsFixed(1) ?? 'N/A'} ft)'),
            const Divider(),
            _buildSpecRow('Mass',
                '${rocket.mass.kg != null ? numberFormat.format(rocket.mass.kg!) : 'N/A'} kg (${rocket.mass.lb != null ? numberFormat.format(rocket.mass.lb!) : 'N/A'} lb)'),
            const Divider(),
            _buildSpecRow('Stages', '${rocket.stages}'),
            const Divider(),
            _buildSpecRow('Boosters', '${rocket.boosters}'),
            const Divider(),
            _buildSpecRow('Cost per Launch',
                '\$${numberFormat.format(rocket.costPerLaunch)}'),
            const Divider(),
            _buildSpecRow('Success Rate', '${rocket.successRatePct}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(GraphQLRocket rocket) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSpecRow('Company', rocket.company),
            const Divider(),
            _buildSpecRow('Country', rocket.country),
            const Divider(),
            _buildSpecRow('First Flight', rocket.firstFlight),
          ],
        ),
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
              context
                  .read<GraphQLRocketBloc>()
                  .add(FetchRocketDetails(widget.rocketId));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
