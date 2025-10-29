import 'package:flutter/material.dart';
import 'package:spacex_information_app/models/company.dart';

Widget buildHistoryCardWidget(Company company) {
  final currentYear = DateTime.now().year;
  final yearsInBusiness = currentYear - company.founded;

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.history,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Founded in ${company.founded}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$yearsInBusiness years of advancing space exploration and technology',
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}
