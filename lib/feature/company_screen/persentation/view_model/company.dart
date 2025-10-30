// Simple Company model for static company information
class Company {
  final String name;
  final String founder;
  final int founded;
  final int employees;
  final int vehicles;
  final int launchSites;
  final int testSites;
  final String ceo;
  final String cto;
  final String coo;
  final String ctoPropulsion;
  final int valuation;
  final Headquarters headquarters;
  final String summary;

  const Company({
    required this.name,
    required this.founder,
    required this.founded,
    required this.employees,
    required this.vehicles,
    required this.launchSites,
    required this.testSites,
    required this.ceo,
    required this.cto,
    required this.coo,
    required this.ctoPropulsion,
    required this.valuation,
    required this.headquarters,
    required this.summary,
  });
}

class Headquarters {
  final String address;
  final String city;
  final String state;

  const Headquarters({
    required this.address,
    required this.city,
    required this.state,
  });
}
