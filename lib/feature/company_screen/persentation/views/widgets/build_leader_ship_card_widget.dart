import 'package:flutter/material.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_leader_row_widget.dart';
import 'package:spacex_information_app/models/company.dart';

Widget buildLeadershipCardWidget(Company company) {
  const divider = Divider();
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildLeaderRowWidget('Founder', company.founder),
          divider,
          buildLeaderRowWidget('CEO', company.ceo),
          divider,
          buildLeaderRowWidget('CTO', company.cto),
          divider,
          buildLeaderRowWidget('COO', company.coo),
          divider,
          buildLeaderRowWidget('CTO Propulsion', company.ctoPropulsion),
        ],
      ),
    ),
  );
}
