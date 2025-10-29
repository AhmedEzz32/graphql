import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../../data/models/space_location.dart';
import '../view_models/map_bloc.dart';
import '../view_models/map_event.dart';
import '../view_models/map_state.dart';
import 'widgets/custom_map_markers.dart';

class SpaceMapScreen extends StatefulWidget {
  const SpaceMapScreen({super.key});

  @override
  State<SpaceMapScreen> createState() => _SpaceMapScreenState();
}

class _SpaceMapScreenState extends State<SpaceMapScreen> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String _selectedLocationId = '';
  bool _showTrajectory = false;

  // Filter options
  bool _showLaunchSites = true;
  bool _showLandingZones = true;
  bool _showDroneShips = true;
  bool _showObservationPoints = false;

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(const LoadMapData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launch Map'),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(_showTrajectory ? Icons.timeline : Icons.show_chart),
            onPressed: _toggleTrajectory,
          ),
        ],
      ),
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoaded) {
            _updateMarkersAndPolylines(state);
          }
        },
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                ),
              );
            }

            if (state is MapError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MapBloc>().add(const LoadMapData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is MapLoaded) {
              return Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(28.6139, -80.6068), // Kennedy Space Center
                      zoom: 6,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    mapType: MapType.normal,
                    style: state.mapStyle.isNotEmpty ? state.mapStyle : null,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                  _buildSearchBar(),
                  _buildLegend(),
                  _buildLocationButton(),
                ],
              );
            }

            return const Center(child: Text('Initializing map...'));
          },
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {}

  Future<void> _updateMarkersAndPolylines(MapLoaded state) async {
    final markers = <Marker>{};
    final polylines = <Polyline>{};

    // Add location markers
    for (final location in state.filteredLocations) {
      if (!_shouldShowLocation(location)) continue;

      final marker = await _createMarkerForLocation(location);
      if (marker != null) {
        markers.add(marker);
      }
    }

    // Add observation point markers
    if (_showObservationPoints) {
      for (final obsPoint in state.observationPoints) {
        final marker = await _createObservationMarker(obsPoint);
        if (marker != null) {
          markers.add(marker);
        }
      }
    }

    // Add user location marker
    if (state.userLatitude != null && state.userLongitude != null) {
      final userMarker = await _createUserLocationMarker(
        LatLng(state.userLatitude!, state.userLongitude!),
      );
      if (userMarker != null) {
        markers.add(userMarker);
      }
    }

    // Add trajectory polyline
    if (state.currentTrajectory != null && _showTrajectory) {
      final polyline = _createTrajectoryPolyline(state.currentTrajectory!);
      polylines.add(polyline);

      // Add trajectory point markers
      for (int i = 0; i < state.currentTrajectory!.points.length; i += 10) {
        final point = state.currentTrajectory!.points[i];
        final marker = await _createTrajectoryMarker(point, i);
        if (marker != null) {
          markers.add(marker);
        }
      }
    }

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
      _polylines.clear();
      _polylines.addAll(polylines);
    });
  }

  bool _shouldShowLocation(SpaceLocation location) {
    switch (location.type) {
      case LocationType.launchSite:
        return _showLaunchSites;
      case LocationType.landingZone:
        return _showLandingZones;
      case LocationType.droneShip:
        return _showDroneShips;
      default:
        return true;
    }
  }

  Future<Marker?> _createMarkerForLocation(SpaceLocation location) async {
    try {
      final isSelected = _selectedLocationId == location.id;

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
        onTap: () => _onMarkerTapped(location),
      );
    } catch (e) {
      return null;
    }
  }

  Future<Marker?> _createObservationMarker(ObservationLocation location) async {
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

  Future<Marker?> _createUserLocationMarker(LatLng position) async {
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

  Future<Marker?> _createTrajectoryMarker(
      TrajectoryPoint point, int index) async {
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

  Polyline _createTrajectoryPolyline(FlightTrajectory trajectory) {
    final points = trajectory.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    return Polyline(
      polylineId: PolylineId('trajectory_${trajectory.launchId}'),
      points: points,
      color: const Color(0xFFFF6B35),
      width: 3,
      patterns: [PatternItem.dash(10), PatternItem.gap(5)],
    );
  }

  Future<BitmapDescriptor> _createBitmapDescriptorFromWidget(
      Widget widget) async {
    // For now, use default markers - in a real app you'd render widgets to bitmaps
    // This is a simplified implementation

    // You can create custom marker icons using BitmapDescriptor.fromAsset()
    // or use the default markers for now
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }

  void _onMarkerTapped(SpaceLocation location) {
    setState(() {
      _selectedLocationId = location.id;
    });

    // Show bottom sheet with location details
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a2e),
      builder: (context) => _buildLocationDetailsSheet(location),
    );
  }

  Widget _buildLocationDetailsSheet(SpaceLocation location) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForLocationType(location.type),
                color: _getColorForLocationType(location.type),
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
          _buildDetailRow('Region', location.region),
          _buildDetailRow('Status', location.isActive ? 'Active' : 'Inactive'),
          if (location.details != null)
            _buildDetailRow('Details', location.details!),
          if (location.supportedVehicles != null)
            _buildDetailRow(
              'Supported Vehicles',
              location.supportedVehicles!.join(', '),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _findObservationPoints(location);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                  ),
                  child: const Text('Find Viewing Spots'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showTrajectoryForLocation(location);
                  },
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

  Widget _buildDetailRow(String label, String value) {
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

  IconData _getIconForLocationType(LocationType type) {
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

  Color _getColorForLocationType(LocationType type) {
    switch (type) {
      case LocationType.launchSite:
        return const Color(0xFFFF6B35);
      case LocationType.landingZone:
        return const Color(0xFF4CAF50);
      case LocationType.droneShip:
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  void _findObservationPoints(SpaceLocation location) {
    final state = context.read<MapBloc>().state;
    if (state is MapLoaded &&
        state.userLatitude != null &&
        state.userLongitude != null) {
      context.read<MapBloc>().add(SearchNearbyObservationPoints(
            latitude: state.userLatitude!,
            longitude: state.userLongitude!,
            launchSiteId: location.id,
          ));
      setState(() {
        _showObservationPoints = true;
      });
    }
  }

  void _showTrajectoryForLocation(SpaceLocation location) {
    context.read<MapBloc>().add(ShowTrajectory(location.id));
    setState(() {
      _showTrajectory = true;
    });
  }

  Widget _buildSearchBar() {
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
          onSubmitted: (query) {
            context.read<MapBloc>().add(SearchPlaces(query));
          },
        ),
      ),
    );
  }

  Widget _buildLegend() {
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
            _buildLegendItem(
                Icons.rocket_launch, 'Launch Sites', const Color(0xFFFF6B35)),
            _buildLegendItem(
                Icons.flight_land, 'Landing Zones', const Color(0xFF4CAF50)),
            _buildLegendItem(
                Icons.directions_boat, 'Drone Ships', const Color(0xFF2196F3)),
            if (_showObservationPoints)
              _buildLegendItem(
                  Icons.visibility, 'Viewing Spots', const Color(0xFFFFD700)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
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

  Widget _buildLocationButton() {
    return Positioned(
      bottom: 40,
      right: 20,
      child: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  void _getCurrentLocation() async {
    try {
      context.read<MapBloc>().add(const LoadMapData());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Locations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Launch Sites'),
              value: _showLaunchSites,
              onChanged: (value) {
                setState(() {
                  _showLaunchSites = value ?? true;
                });
                _updateFilters();
              },
            ),
            CheckboxListTile(
              title: const Text('Landing Zones'),
              value: _showLandingZones,
              onChanged: (value) {
                setState(() {
                  _showLandingZones = value ?? true;
                });
                _updateFilters();
              },
            ),
            CheckboxListTile(
              title: const Text('Drone Ships'),
              value: _showDroneShips,
              onChanged: (value) {
                setState(() {
                  _showDroneShips = value ?? true;
                });
                _updateFilters();
              },
            ),
            CheckboxListTile(
              title: const Text('Viewing Spots'),
              value: _showObservationPoints,
              onChanged: (value) {
                setState(() {
                  _showObservationPoints = value ?? false;
                });
                _updateFilters();
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
    );
  }

  void _updateFilters() {
    final selectedTypes = <String>[];
    if (_showLaunchSites) selectedTypes.add('launchSite');
    if (_showLandingZones) selectedTypes.add('landingZone');
    if (_showDroneShips) selectedTypes.add('droneShip');

    context.read<MapBloc>().add(FilterLocationsByType(selectedTypes));
  }

  void _toggleTrajectory() {
    if (_showTrajectory) {
      context.read<MapBloc>().add(const HideTrajectory());
      setState(() {
        _showTrajectory = false;
      });
    } else {
      // Show trajectory for Kennedy Space Center as default
      context.read<MapBloc>().add(const ShowTrajectory('ksc_lc_39a'));
      setState(() {
        _showTrajectory = true;
      });
    }
  }
}
