import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_history_card_widget.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_leader_row_widget.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_metrics_card_widget.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_valuation_card_widget.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/view_model/company.dart';

Widget buildCompanyInfoWidget(BuildContext context, Company company) {
  final numberFormat = NumberFormat('#,###');

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[700]!,
                Colors.blue[900]!,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.rocket_launch,
                      size: 32,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Founded ${company.founded}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                company.summary,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Key Metrics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            buildMetricCardWidget(
              'Employees',
              numberFormat.format(company.employees),
              Icons.people,
              Colors.blue,
            ),
            buildMetricCardWidget(
              'Vehicles',
              company.vehicles.toString(),
              Icons.rocket,
              Colors.green,
            ),
            buildMetricCardWidget(
              'Launch Sites',
              company.launchSites.toString(),
              Icons.launch,
              Colors.orange,
            ),
            buildMetricCardWidget(
              'Test Sites',
              company.testSites.toString(),
              Icons.science,
              Colors.purple,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Leadership',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        buildLeaderRowWidget('Founder', company.founder),
        const SizedBox(height: 24),
        Text(
          'Headquarters',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        buildValuationCardWidget(context, company, numberFormat),
        const SizedBox(height: 24),
        Text(
          'Company History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        buildHistoryCardWidget(company),
      ],
    ),
  );
}
