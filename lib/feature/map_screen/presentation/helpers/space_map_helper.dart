import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/space_location.dart';
import '../views/widgets/custom_map_markers.dart';

class SpaceMapHelper {
  static const LatLng kennedySpaceCenter = LatLng(28.6139, -80.6068);

  // Colors for different location types
  static const Color launchSiteColor = Color(0xFFFF6B35);
  static const Color landingZoneColor = Color(0xFF4CAF50);
  static const Color droneShipColor = Color(0xFF2196F3);
  static const Color trajectoryColor = Color(0xFFFF6B35);

  /// Creates a marker for a space location
  static Future<Marker?> createMarkerForLocation(
    SpaceLocation location, {
    required String selectedLocationId,
    required VoidCallback onTap,
  }) async {
    try {
      final isSelected = selectedLocationId == location.id;

      Widget markerWidget;
      switch (location.type) {
        case LocationType.launchSite:
          markerWidget = CustomMapMarkers.buildLaunchSiteMarker(
            location: location,
            isSelected: isSelected,
          );
          break;
        case LocationType.landingZone:
          markerWidget = CustomMapMarkers.buildLandingZoneMarker(
            location: location,
            isSelected: isSelected,
          );
          break;
        case LocationType.droneShip:
          markerWidget = CustomMapMarkers.buildDroneShipMarker(
            location: location,
            isSelected: isSelected,
          );
          break;
        default:
          return null;
      }

      final icon = await _createBitmapDescriptorFromWidget(markerWidget);

      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.latitude, location.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.description,
        ),
        onTap: onTap,
      );
    } catch (e) {
      return null;
    }
  }

  /// Creates a marker for observation points
  static Future<Marker?> createObservationMarker(
    ObservationLocation location,
  ) async {
    try {
      final markerWidget = CustomMapMarkers.buildObservationPointMarker(
        location: location,
        isRecommended: location.isRecommended,
      );

      final icon = await _createBitmapDescriptorFromWidget(markerWidget);

      return Marker(
        markerId: MarkerId('obs_${location.latitude}_${location.longitude}'),
        position: LatLng(location.latitude, location.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: location.name,
          snippet: 'Distance: ${location.distance.toStringAsFixed(1)}km • '
              'Visibility: ${(location.visibility * 100).toStringAsFixed(0)}%',
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Creates a marker for user location
  static Future<Marker?> createUserLocationMarker(LatLng position) async {
    try {
      final markerWidget = CustomMapMarkers.buildUserLocationMarker();
      final icon = await _createBitmapDescriptorFromWidget(markerWidget);

      return Marker(
        markerId: const MarkerId('user_location'),
        position: position,
        icon: icon,
        infoWindow: const InfoWindow(
          title: 'Your Location',
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Creates a marker for trajectory points
  static Future<Marker?> createTrajectoryMarker(
    TrajectoryPoint point,
    int index,
  ) async {
    try {
      final markerWidget = CustomMapMarkers.buildTrajectoryMarker(
        point: point,
        isActive: index % 30 == 0, // Show icon every 30 points
      );

      final icon = await _createBitmapDescriptorFromWidget(markerWidget);

      return Marker(
        markerId: MarkerId('trajectory_$index'),
        position: LatLng(point.latitude, point.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: 'T+${point.timestamp}s',
          snippet: '${point.phase.toUpperCase()} • '
              'Alt: ${(point.altitude / 1000).toStringAsFixed(1)}km • '
              'Vel: ${point.velocity.toStringAsFixed(0)}m/s',
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Creates a polyline for flight trajectory
  static Polyline createTrajectoryPolyline(FlightTrajectory trajectory) {
    final points = trajectory.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    return Polyline(
      polylineId: PolylineId('trajectory_${trajectory.launchId}'),
      points: points,
      color: trajectoryColor,
      width: 3,
      patterns: [PatternItem.dash(10), PatternItem.gap(5)],
    );
  }

  /// Determines if a location should be shown based on filter settings
  static bool shouldShowLocation(
    SpaceLocation location, {
    required bool showLaunchSites,
    required bool showLandingZones,
    required bool showDroneShips,
  }) {
    switch (location.type) {
      case LocationType.launchSite:
        return showLaunchSites;
      case LocationType.landingZone:
        return showLandingZones;
      case LocationType.droneShip:
        return showDroneShips;
      default:
        return true;
    }
  }

  /// Gets the appropriate icon for a location type
  static IconData getIconForLocationType(LocationType type) {
    switch (type) {
      case LocationType.launchSite:
        return Icons.rocket_launch;
      case LocationType.landingZone:
        return Icons.flight_land;
      case LocationType.droneShip:
        return Icons.directions_boat;
      default:
        return Icons.place;
    }
  }

  /// Gets the appropriate color for a location type
  static Color getColorForLocationType(LocationType type) {
    switch (type) {
      case LocationType.launchSite:
        return launchSiteColor;
      case LocationType.landingZone:
        return landingZoneColor;
      case LocationType.droneShip:
        return droneShipColor;
      default:
        return Colors.grey;
    }
  }

  /// Builds a detail row widget for location information
  static Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a legend item for the map
  static Widget buildLegendItem(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a search bar widget for the map
  static Widget buildSearchBar({
    required Function(String) onSearch,
  }) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Search places...',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
          onSubmitted: onSearch,
        ),
      ),
    );
  }

  /// Creates a legend widget for the map
  static Widget buildLegend() {
    return Positioned(
      bottom: 100,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legend',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            buildLegendItem(
              Icons.rocket_launch,
              'Launch Sites',
              launchSiteColor,
            ),
            buildLegendItem(
              Icons.flight_land,
              'Landing Zones',
              landingZoneColor,
            ),
            buildLegendItem(
              Icons.directions_boat,
              'Drone Ships',
              droneShipColor,
            ),
            buildLegendItem(
              Icons.visibility,
              'Viewing Spots',
              const Color(0xFFFFD700),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a location button widget
  static Widget buildLocationButton({
    required VoidCallback onPressed,
  }) {
    return Positioned(
      bottom: 40,
      right: 20,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: launchSiteColor,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  /// Creates a location details bottom sheet
  static Widget buildLocationDetailsSheet(
    SpaceLocation location, {
    required VoidCallback onFindViewingSpots,
    required VoidCallback onShowTrajectory,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                getIconForLocationType(location.type),
                color: getColorForLocationType(location.type),
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      location.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildDetailRow('Region', location.region),
          buildDetailRow('Status', location.isActive ? 'Active' : 'Inactive'),
          if (location.details != null)
            buildDetailRow('Details', location.details!),
          if (location.supportedVehicles != null)
            buildDetailRow(
              'Supported Vehicles',
              location.supportedVehicles!.join(', '),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onFindViewingSpots,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: launchSiteColor,
                  ),
                  child: const Text('Find Viewing Spots'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onShowTrajectory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                  child: const Text('Show Trajectory'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Creates a filter dialog
  static void showFilterDialog(
    BuildContext context, {
    required bool showLaunchSites,
    required bool showLandingZones,
    required bool showDroneShips,
    required Function(bool) onLaunchSitesChanged,
    required Function(bool) onLandingZonesChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter Locations'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Launch Sites'),
                value: showLaunchSites,
                onChanged: (value) {
                  setState(() {});
                  onLaunchSitesChanged(value ?? true);
                },
              ),
              CheckboxListTile(
                title: const Text('Landing Zones'),
                value: showLandingZones,
                onChanged: (value) {
                  setState(() {});
                  onLandingZonesChanged(value ?? true);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the space-themed map style
  static String getSpaceMapStyle() {
    return '''
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#1a1a2e"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8ec3b9"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1a1a2e"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6cb7"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#64779e"
          }
        ]
      },
      {
        "featureType": "administrative.province",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6cb7"
          }
        ]
      },
      {
        "featureType": "landscape.man_made",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#334e87"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#6f9ba4"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3C7680"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#304a7d"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#2c6675"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#255763"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#b0d5ce"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3a4762"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#0e1626"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#4e6d70"
          }
        ]
      }
    ]
    ''';
  }

  /// Private helper method to create bitmap descriptor from widget
  static Future<BitmapDescriptor> _createBitmapDescriptorFromWidget(
      Widget widget) async {
    // For now, use default markers - in a real app you'd render widgets to bitmaps
    // This is a simplified implementation
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }
}
