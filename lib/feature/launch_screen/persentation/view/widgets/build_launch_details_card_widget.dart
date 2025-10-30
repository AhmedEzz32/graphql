import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'build_details_row_widget.dart';
import '../../view_model/graphql_launch_models.dart';

Widget buildGraphQLLaunchDetailsCard(
    BuildContext context, GraphQLLaunch launch, DateTime? launchDate) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Launch Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          buildDetailRowWidget('Mission', 'No Name'),
          // buildDetailRowWidget('Flight Number', launch.flightNumber.toString()),
          if (launchDate != null) ...[
            buildDetailRowWidget(
                'Date', DateFormat('MMMM dd, yyyy').format(launchDate)),
            buildDetailRowWidget(
                'Time (UTC)', DateFormat('HH:mm:ss').format(launchDate)),
          ] else
            buildDetailRowWidget('Date', 'TBD'),
          if (launch.staticFireDateUtc != null)
            buildDetailRowWidget(
                'Static Fire',
                DateFormat('MMMM dd, yyyy')
                    .format(DateTime.parse(launch.staticFireDateUtc!))),
          buildDetailRowWidget('TBD', launch.tbd == true ? 'Yes' : 'No'),
          buildDetailRowWidget(
              'Upcoming', launch.upcoming == true ? 'Yes' : 'No'),
          if (launch.success != null)
            buildDetailRowWidget(
                'Launch Success', launch.success! ? 'Yes' : 'No'),
          if (launch.details != null && launch.details!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mission Details',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    launch.details!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          if (launch.rocket.name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rocket Information',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWidget('Rocket Name', launch.rocket.name),
                  buildDetailRowWidget('Rocket Type', launch.rocket.type),
                ],
              ),
            ),
          if (launch.launchpad?.name?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Launch Site',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWidget(
                      'Site Name', launch.launchpad!.name ?? 'Unknown'),
                  buildDetailRowWidget('Site Name Long',
                      launch.launchpad!.fullName ?? 'Unknown'),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
