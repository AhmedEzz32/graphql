import 'package:flutter/material.dart';
import 'package:spacex_information_app/feature/company_screen/persentation/views/widgets/build_company_info_widget.dart';
import '../view_model/company.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  late final Company _companyData;

  @override
  void initState() {
    super.initState();
    _companyData = const Company(
      name: 'Space Exploration Technologies Corp.',
      founder: 'Elon Musk',
      founded: 2002,
      employees: 12000,
      vehicles: 3,
      launchSites: 3,
      testSites: 3,
      ceo: 'Elon Musk',
      cto: 'Elon Musk',
      coo: 'Gwynne Shotwell',
      ctoPropulsion: 'Tom Mueller',
      valuation: 137000000000,
      headquarters: Headquarters(
        address: 'Rocket Road',
        city: 'Cairo',
        state: 'Egypt',
      ),
      summary:
          'SpaceX designs, manufactures and launches advanced rockets and spacecraft. The company was founded in 2002 to revolutionize space technology, with the ultimate goal of enabling people to live on other planets.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildCompanyInfoWidget(context, _companyData),
    );
  }
}
