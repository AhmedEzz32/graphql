import 'dart:math';
import 'package:spacex_information_app/feature/map_screen/data/models/space_location.dart';

class MockSpaceDataService {
  static const Map<String, SpaceLocation> _launchSites = {
    'ksc_lc_39a': SpaceLocation(
      id: 'ksc_lc_39a',
      name: 'LC-39A',
      description: 'Kennedy Space Center Launch Complex 39A',
      latitude: 28.6083,
      longitude: -80.6041,
      type: LocationType.launchSite,
      region: 'Florida',
      isActive: true,
      details: 'Historic launch pad used for Apollo and Space Shuttle missions',
      supportedVehicles: ['Falcon 9', 'Falcon Heavy', 'Dragon'],
    ),
    'ksc_lc_40': SpaceLocation(
      id: 'ksc_lc_40',
      name: 'SLC-40',
      description: 'Cape Canaveral Space Launch Complex 40',
      latitude: 28.5618,
      longitude: -80.5772,
      type: LocationType.launchSite,
      region: 'Florida',
      isActive: true,
      details: 'Primary Falcon 9 launch site',
      supportedVehicles: ['Falcon 9'],
    ),
    'vafb_slc_4e': SpaceLocation(
      id: 'vafb_slc_4e',
      name: 'SLC-4E',
      description: 'Vandenberg Space Launch Complex 4E',
      latitude: 34.6440,
      longitude: -120.5931,
      type: LocationType.launchSite,
      region: 'California',
      isActive: true,
      details: 'West Coast launch site for polar and sun-synchronous orbits',
      supportedVehicles: ['Falcon 9'],
    ),
    'boca_chica': SpaceLocation(
      id: 'boca_chica',
      name: 'Starbase',
      description: 'SpaceX Starship Development and Launch Facility',
      latitude: 25.9972,
      longitude: -97.1572,
      type: LocationType.launchSite,
      region: 'Texas',
      isActive: true,
      details: 'Development and future launch site for Starship',
      supportedVehicles: ['Starship', 'Super Heavy'],
    ),
  };

  static const Map<String, SpaceLocation> _landingZones = {
    'lz_1': SpaceLocation(
      id: 'lz_1',
      name: 'LZ-1',
      description: 'Landing Zone 1',
      latitude: 28.4858,
      longitude: -80.5444,
      type: LocationType.landingZone,
      region: 'Florida',
      isActive: true,
      details: 'Primary land-based recovery site',
    ),
    'lz_2': SpaceLocation(
      id: 'lz_2',
      name: 'LZ-2',
      description: 'Landing Zone 2',
      latitude: 28.4858,
      longitude: -80.5347,
      type: LocationType.landingZone,
      region: 'Florida',
      isActive: true,
      details: 'Secondary land-based recovery site',
    ),
    'lz_4': SpaceLocation(
      id: 'lz_4',
      name: 'LZ-4',
      description: 'Landing Zone 4',
      latitude: 34.6318,
      longitude: -120.6156,
      type: LocationType.landingZone,
      region: 'California',
      isActive: true,
      details: 'West Coast landing zone',
    ),
  };

  static const Map<String, SpaceLocation> _droneShips = {
    'ocisly': SpaceLocation(
      id: 'ocisly',
      name: 'Of Course I Still Love You',
      description: 'Autonomous Spaceport Drone Ship',
      latitude: 28.4, // Dynamic position - this is approximate
      longitude: -80.0,
      type: LocationType.droneShip,
      region: 'Atlantic Ocean',
      isActive: true,
      details: 'East Coast recovery vessel',
    ),
    'jrti': SpaceLocation(
      id: 'jrti',
      name: 'Just Read The Instructions',
      description: 'Autonomous Spaceport Drone Ship',
      latitude: 33.9,
      longitude: -118.4,
      type: LocationType.droneShip,
      region: 'Pacific Ocean',
      isActive: true,
      details: 'West Coast recovery vessel',
    ),
  };

  static List<SpaceLocation> getAllLocations() {
    return [
      ..._launchSites.values,
      ..._landingZones.values,
      ..._droneShips.values,
    ];
  }

  static List<SpaceLocation> getLaunchSites() {
    return _launchSites.values.toList();
  }

  static List<SpaceLocation> getLandingZones() {
    return _landingZones.values.toList();
  }

  static List<SpaceLocation> getDroneShips() {
    return _droneShips.values.toList();
  }

  static SpaceLocation? getLocationById(String id) {
    return getAllLocations().firstWhere(
      (location) => location.id == id,
      orElse: () => throw Exception('Location not found'),
    );
  }

  // Generate mock trajectory data
  static FlightTrajectory generateMockTrajectory(
      String launchId, String missionName) {
    final launchSite = _launchSites['ksc_lc_39a']!;
    final landingSite = _landingZones['lz_1']!;

    final points = <TrajectoryPoint>[];
    final random = Random();

    // Launch phase (0-2 minutes)
    for (int i = 0; i <= 120; i += 5) {
      points.add(TrajectoryPoint(
        latitude: launchSite.latitude + (i * 0.001),
        longitude: launchSite.longitude + (i * 0.001),
        altitude: i * i * 0.5, // Accelerating altitude gain
        velocity: i * 10, // Increasing velocity
        timestamp: i,
        phase: i < 60 ? 'launch' : 'ascent',
      ));
    }

    // Orbit phase (simplified circular path)
    for (int i = 121; i <= 3600; i += 60) {
      final angle = (i - 120) * 0.01;
      points.add(TrajectoryPoint(
        latitude: launchSite.latitude + 20 * sin(angle),
        longitude: launchSite.longitude + 20 * cos(angle),
        altitude: 400000, // 400km orbit
        velocity: 7800, // Orbital velocity
        timestamp: i,
        phase: 'orbit',
      ));
    }

    // Descent and landing (for booster)
    for (int i = 3601; i <= 3900; i += 10) {
      final progress = (i - 3600) / 300.0;
      points.add(TrajectoryPoint(
        latitude: launchSite.latitude +
            (landingSite.latitude - launchSite.latitude) * progress,
        longitude: launchSite.longitude +
            (landingSite.longitude - launchSite.longitude) * progress,
        altitude: 50000 * (1 - progress),
        velocity: 500 * (1 - progress),
        timestamp: i,
        phase: i < 3850 ? 'descent' : 'landing',
      ));
    }

    return FlightTrajectory(
      launchId: launchId,
      missionName: missionName,
      points: points,
      launchSiteId: launchSite.id,
      landingSiteId: landingSite.id,
      launchTime: DateTime.now().subtract(Duration(hours: random.nextInt(720))),
    );
  }

  // Generate observation points based on user location
  static List<ObservationLocation> getObservationPoints(
    double userLatitude,
    double userLongitude,
    String launchSiteId,
  ) {
    final launchSite = getLocationById(launchSiteId);
    if (launchSite == null) return [];

    final random = Random();
    final observations = <ObservationLocation>[];

    // Generate points in a radius around the launch site
    for (int i = 0; i < 10; i++) {
      final distance = 50 + random.nextInt(200);
      final angle = random.nextDouble() * 2 * pi;

      final lat = launchSite.latitude + (distance / 111.0) * cos(angle);
      final lng = launchSite.longitude +
          (distance / 111.0) * sin(angle) / cos(launchSite.latitude * pi / 180);

      final userDistance =
          _calculateDistance(userLatitude, userLongitude, lat, lng);
      final visibility = _calculateVisibility(distance, random);

      observations.add(ObservationLocation(
        name: 'Viewing Point ${i + 1}',
        latitude: lat,
        longitude: lng,
        distance: distance.toDouble(),
        visibility: visibility,
        weatherConditions: _getRandomWeather(random),
        isRecommended: visibility > 0.7 && userDistance < 100,
      ));
    }

    // Sort by distance from user
    observations.sort((a, b) {
      final distA = _calculateDistance(
          userLatitude, userLongitude, a.latitude, a.longitude);
      final distB = _calculateDistance(
          userLatitude, userLongitude, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });

    return observations;
  }

  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final double dLat = (lat2 - lat1) * (pi / 180);
    final double dLon = (lon2 - lon1) * (pi / 180);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _calculateVisibility(int distance, Random random) {
    // Closer is generally better, but add some randomness for weather/terrain
    final baseVisibility = max(0.1, 1.0 - (distance / 300.0));
    return min(1.0, baseVisibility + (random.nextDouble() - 0.5) * 0.3);
  }

  static String _getRandomWeather(Random random) {
    final conditions = [
      'Clear',
      'Partly Cloudy',
      'Cloudy',
      'Light Rain',
      'Clear Skies'
    ];
    return conditions[random.nextInt(conditions.length)];
  }
}
