import 'dart:math';
import 'space_location.dart';

class ConstantMapData {
  // Real SpaceX launch sites with accurate coordinates
  static const Map<String, SpaceLocation> launchSites = {
    'ksc_lc_39a': SpaceLocation(
      id: 'ksc_lc_39a',
      name: 'LC-39A',
      description: 'Kennedy Space Center Launch Complex 39A',
      latitude: 28.6084,
      longitude: -80.6040,
      type: LocationType.launchSite,
      region: 'Kennedy Space Center, Florida',
      isActive: true,
      details: 'Primary Falcon Heavy and Crew Dragon launch site',
      supportedVehicles: ['Falcon Heavy', 'Falcon 9', 'Dragon'],
    ),
    'ksc_lc_40': SpaceLocation(
      id: 'ksc_lc_40',
      name: 'SLC-40',
      description: 'Cape Canaveral Space Launch Complex 40',
      latitude: 28.5618,
      longitude: -80.5772,
      type: LocationType.launchSite,
      region: 'Cape Canaveral Space Force Station, Florida',
      isActive: true,
      details: 'Primary Falcon 9 launch site for commercial missions',
      supportedVehicles: ['Falcon 9'],
    ),
    'vafb_slc_4e': SpaceLocation(
      id: 'vafb_slc_4e',
      name: 'SLC-4E',
      description: 'Vandenberg Space Launch Complex 4E',
      latitude: 34.6332,
      longitude: -120.6156,
      type: LocationType.launchSite,
      region: 'Vandenberg Space Force Base, California',
      isActive: true,
      details: 'West Coast launch site for polar and sun-synchronous orbits',
      supportedVehicles: ['Falcon 9'],
    ),
    'stls': SpaceLocation(
      id: 'stls',
      name: 'Starbase',
      description: 'SpaceX South Texas Launch Site',
      latitude: 25.9972,
      longitude: -97.1563,
      type: LocationType.launchSite,
      region: 'Boca Chica, Texas',
      isActive: true,
      details: 'Starship development and launch facility',
      supportedVehicles: ['Starship', 'Super Heavy'],
    ),
  };

  // Real SpaceX landing zones with accurate coordinates
  static const Map<String, SpaceLocation> landingZones = {
    'lz_1': SpaceLocation(
      id: 'lz_1',
      name: 'LZ-1',
      description: 'Landing Zone 1',
      latitude: 28.4858,
      longitude: -80.5444,
      type: LocationType.landingZone,
      region: 'Cape Canaveral Space Force Station, Florida',
      isActive: true,
      details: 'Primary east coast booster recovery site',
      supportedVehicles: ['Falcon 9 Booster'],
    ),
    'lz_2': SpaceLocation(
      id: 'lz_2',
      name: 'LZ-2',
      description: 'Landing Zone 2',
      latitude: 28.4856,
      longitude: -80.5413,
      type: LocationType.landingZone,
      region: 'Cape Canaveral Space Force Station, Florida',
      isActive: true,
      details: 'Secondary east coast booster recovery site',
      supportedVehicles: ['Falcon 9 Booster'],
    ),
    'lz_4': SpaceLocation(
      id: 'lz_4',
      name: 'LZ-4',
      description: 'Landing Zone 4',
      latitude: 34.6330,
      longitude: -120.6156,
      type: LocationType.landingZone,
      region: 'Vandenberg Space Force Base, California',
      isActive: true,
      details: 'West coast booster recovery site',
      supportedVehicles: ['Falcon 9 Booster'],
    ),
  };

  // Autonomous Spaceport Drone Ships (ASDS)
  static const Map<String, SpaceLocation> droneShips = {
    'ocisly': SpaceLocation(
      id: 'ocisly',
      name: 'Of Course I Still Love You',
      description: 'Autonomous Spaceport Drone Ship',
      latitude: 28.4, // Atlantic position varies
      longitude: -80.0,
      type: LocationType.droneShip,
      region: 'Atlantic Ocean',
      isActive: true,
      details: 'East coast autonomous recovery vessel',
      supportedVehicles: ['Falcon 9 Booster'],
    ),
    'jrti': SpaceLocation(
      id: 'jrti',
      name: 'Just Read The Instructions',
      description: 'Autonomous Spaceport Drone Ship',
      latitude: 33.9, // Pacific position varies
      longitude: -118.4,
      type: LocationType.droneShip,
      region: 'Pacific Ocean',
      isActive: true,
      details: 'West coast autonomous recovery vessel',
      supportedVehicles: ['Falcon 9 Booster'],
    ),
    'asog': SpaceLocation(
      id: 'asog',
      name: 'A Shortfall of Gravitas',
      description: 'Autonomous Spaceport Drone Ship',
      latitude: 28.5, // Atlantic position varies
      longitude: -79.8,
      type: LocationType.droneShip,
      region: 'Atlantic Ocean',
      isActive: true,
      details: 'East coast autonomous recovery vessel',
      supportedVehicles: ['Falcon 9 Booster'],
    ),
  };

  // Prime observation locations for watching launches
  static const Map<String, ObservationLocation> observationPoints = {
    // Kennedy Space Center area
    'ksc_visitor_complex': ObservationLocation(
      name: 'KSC Visitor Complex',
      latitude: 28.5244,
      longitude: -80.6831,
      distance: 6.5,
      visibility: 1.0,
      weatherConditions: 'Excellent',
      isRecommended: true,
    ),
    'cherie_down_park': ObservationLocation(
      name: 'Cherie Down Park',
      latitude: 28.4183,
      longitude: -80.6103,
      distance: 8.2,
      visibility: 0.95,
      weatherConditions: 'Excellent',
      isRecommended: true,
    ),
    'cocoa_beach': ObservationLocation(
      name: 'Cocoa Beach',
      latitude: 28.3200,
      longitude: -80.6075,
      distance: 12.4,
      visibility: 0.85,
      weatherConditions: 'Good',
      isRecommended: true,
    ),
    'titusville': ObservationLocation(
      name: 'Titusville',
      latitude: 28.6122,
      longitude: -80.8075,
      distance: 15.8,
      visibility: 0.75,
      weatherConditions: 'Good',
      isRecommended: false,
    ),
    'new_smyrna_beach': ObservationLocation(
      name: 'New Smyrna Beach',
      latitude: 29.0258,
      longitude: -80.9270,
      distance: 35.2,
      visibility: 0.60,
      weatherConditions: 'Fair',
      isRecommended: false,
    ),
    // Vandenberg area
    'surf_beach': ObservationLocation(
      name: 'Surf Beach',
      latitude: 34.6893,
      longitude: -120.6306,
      distance: 8.1,
      visibility: 0.90,
      weatherConditions: 'Good',
      isRecommended: true,
    ),
    'jalama_beach': ObservationLocation(
      name: 'Jalama Beach County Park',
      latitude: 34.4958,
      longitude: -120.5011,
      distance: 18.3,
      visibility: 0.80,
      weatherConditions: 'Good',
      isRecommended: true,
    ),
    'pismo_beach': ObservationLocation(
      name: 'Pismo Beach',
      latitude: 35.1428,
      longitude: -120.6413,
      distance: 45.6,
      visibility: 0.65,
      weatherConditions: 'Fair',
      isRecommended: false,
    ),
    // Starbase area
    'boca_chica_beach': ObservationLocation(
      name: 'Boca Chica Beach',
      latitude: 25.9919,
      longitude: -97.1503,
      distance: 1.2,
      visibility: 1.0,
      weatherConditions: 'Excellent',
      isRecommended: true,
    ),
    'south_padre_island': ObservationLocation(
      name: 'South Padre Island',
      latitude: 26.1118,
      longitude: -97.1681,
      distance: 8.4,
      visibility: 0.85,
      weatherConditions: 'Good',
      isRecommended: true,
    ),
  };

  // Getter methods for easy access
  static List<SpaceLocation> getAllLaunchSites() {
    return launchSites.values.toList();
  }

  static List<SpaceLocation> getAllLandingZones() {
    return landingZones.values.toList();
  }

  static List<SpaceLocation> getAllDroneShips() {
    return droneShips.values.toList();
  }

  static List<SpaceLocation> getAllLocations() {
    return [
      ...launchSites.values,
      ...landingZones.values,
      ...droneShips.values,
    ];
  }

  static List<ObservationLocation> getAllObservationPoints() {
    return observationPoints.values.toList();
  }

  static SpaceLocation? getLocationById(String id) {
    final allLocations = getAllLocations();
    try {
      return allLocations.firstWhere((location) => location.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ObservationLocation> getObservationPointsNearLocation(
      String locationId) {
    final location = getLocationById(locationId);
    if (location == null) return [];

    // Return observation points within 50km of the location
    return observationPoints.values.where((obs) {
      final distance = _calculateDistance(
        location.latitude,
        location.longitude,
        obs.latitude,
        obs.longitude,
      );
      return distance <= 50.0;
    }).toList();
  }

  // Haversine formula for calculating distance between two points
  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
