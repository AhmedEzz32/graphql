import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacex_information_app/core/widgets/generic_build_list.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/graphql_launch_models.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views/widgets/build_rocket_card.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/graphql_rocket_models.dart';

class RocketHelper {
  Widget buildRocketDetails(GraphQLRocket rocket, BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    const sizedBox24 = SizedBox(height: 24);
    const sizedBox12 = SizedBox(height: 12);

    return SingleChildScrollView(
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
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rocket.type,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey[600]),
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
          if (rocket.country.isNotEmpty) ...[
            Text(
              'Gallery',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            sizedBox12,
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
            sizedBox24,
          ],
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
          sizedBox24,
          Text(
            'Specifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          sizedBox12,
          _buildSpecsGrid(rocket, numberFormat),
          sizedBox24,
          Text(
            'Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          sizedBox12,
          _buildDetailsCard(rocket),
          sizedBox24,
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

  Widget buildLaunchCard(GraphQLLaunch launch) {
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

  Widget buildRocketList(List<GraphQLRocket> rockets) {
    return GenericBuildList(
        data: rockets,
        itemBuilder: (BuildContext context, GraphQLRocket item) {
          return buildRocketCard(context, item);
        });
  }
}
