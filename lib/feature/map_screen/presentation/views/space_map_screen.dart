import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../view_models/map_bloc.dart';
import '../view_models/map_event.dart';
import '../view_models/map_state.dart';
import '../helpers/space_map_helper.dart';

class SpaceMapScreen extends StatefulWidget {
  const SpaceMapScreen({super.key});

  @override
  State<SpaceMapScreen> createState() => _SpaceMapScreenState();
}

class _SpaceMapScreenState extends State<SpaceMapScreen> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _showTrajectory = false;

  // Filter options
  bool _showLaunchSites = true;
  bool _showLandingZones = true;

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
            // _updateMarkersAndPolylines(state);
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
                    style: _getSpaceMapStyle(),
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

  Widget _buildSearchBar() {
    return SpaceMapHelper.buildSearchBar(
      onSearch: (query) {
        context.read<MapBloc>().add(SearchPlaces(query));
      },
    );
  }

  Widget _buildLegend() {
    return SpaceMapHelper.buildLegend();
  }

  Widget _buildLocationButton() {
    return SpaceMapHelper.buildLocationButton(
      onPressed: _getCurrentLocation,
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
    SpaceMapHelper.showFilterDialog(
      context,
      showLaunchSites: _showLaunchSites,
      showLandingZones: _showLandingZones,
      showDroneShips: true,
      onLaunchSitesChanged: (value) {
        setState(() {
          _showLaunchSites = value;
        });
      },
      onLandingZonesChanged: (value) {
        setState(() {
          _showLandingZones = value;
        });
      },
    );
  }

  String _getSpaceMapStyle() {
    return SpaceMapHelper.getSpaceMapStyle();
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

  // void _findObservationPoints(SpaceLocation location) {
  //   // For now, just show a placeholder since the MapState structure is different
  //   setState(() {});

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //         content: Text('Finding viewing spots feature coming soon!')),
  //   );
  // }

  // void _showTrajectoryForLocation(SpaceLocation location) {
  //   context.read<MapBloc>().add(ShowTrajectory(location.id));
  //   setState(() {
  //     _showTrajectory = true;
  //   });
  // }

  // bool _shouldShowLocation(SpaceLocation location) {
  //   return SpaceMapHelper.shouldShowLocation(
  //     location,
  //     showLaunchSites: _showLaunchSites,
  //     showLandingZones: _showLandingZones,
  //     showDroneShips: true,
  //   );
  // }

  // Future<BitmapDescriptor> _createBitmapDescriptorFromWidget(
  //     Widget widget) async {
  //   // For now, use default markers - in a real app you'd render widgets to bitmaps
  //   // This is a simplified implementation

  //   // You can create custom marker icons using BitmapDescriptor.fromAsset()
  //   // or use the default markers for now
  //   return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  // }

  // void _onMarkerTapped(SpaceLocation location) {
  //   setState(() {});

  //   // Show bottom sheet with location details
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: const Color(0xFF1a1a2e),
  //     builder: (context) => SpaceMapHelper.buildLocationDetailsSheet(
  //       location,
  //       onFindViewingSpots: () {
  //         Navigator.pop(context);
  //         _findObservationPoints(location);
  //       },
  //       onShowTrajectory: () {
  //         Navigator.pop(context);
  //         _showTrajectoryForLocation(location);
  //       },
  //     ),
  //   );
  // }

 /* Future<void> _updateMarkersAndPolylines(MapLoaded state) async {
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
  } */
