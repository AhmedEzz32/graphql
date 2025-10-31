import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/space_map_bloc.dart';
import '../../../data/space_map_event.dart';
import '../../../data/space_map_state.dart';

class SpaceMapWidget extends StatelessWidget {
  const SpaceMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpaceMapBloc(),
      child: const _SpaceMapView(),
    );
  }
}

class _SpaceMapView extends StatelessWidget {
  const _SpaceMapView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpaceMapBloc, SpaceMapState>(
      listener: (context, state) {
        if (state is SpaceMapLoaded &&
            !state.isAnimating &&
            state.animationProgress == 100) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("🎉 Mission Complete! Rocket reached destination!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SpaceMapInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final spaceMapState = state as SpaceMapLoaded;

        return Scaffold(
          appBar: AppBar(
            title: const Text("🚀 Rocket Route Animation"),
            backgroundColor: const Color(0xFF1a1a2e),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear',
                onPressed: () =>
                    context.read<SpaceMapBloc>().add(const ClearMap()),
              ),
            ],
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.7749, -122.4194),
                  zoom: 10,
                ),
                mapType: MapType.normal,
                markers: spaceMapState.markers,
                polylines: spaceMapState.polylines,
                zoomControlsEnabled: true,
                onTap: (tappedPoint) =>
                    context.read<SpaceMapBloc>().add(MapTapped(tappedPoint)),
              ),
              if (!spaceMapState.iconLoaded)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (spaceMapState.curvePoints.isNotEmpty &&
                  !spaceMapState.isAnimating &&
                  spaceMapState.iconLoaded)
                FloatingActionButton.extended(
                  onPressed: () => context
                      .read<SpaceMapBloc>()
                      .add(const StartRocketAnimation()),
                  heroTag: "animate_rocket",
                  label: const Text("Launch Rocket"),
                  icon: const Icon(Icons.rocket_launch),
                  backgroundColor: Colors.orange,
                ),
              const SizedBox(height: 10),
              FloatingActionButton.extended(
                onPressed: spaceMapState.iconLoaded
                    ? () {
                        if (spaceMapState.origin != null &&
                            spaceMapState.destination != null) {
                          context.read<SpaceMapBloc>().add(
                                CreateCurvedRoute(
                                  origin: spaceMapState.origin!,
                                  destination: spaceMapState.destination!,
                                ),
                              );
                          _showRouteCreatedMessage(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Tap twice on map: first for start point, then for destination"),
                            ),
                          );
                        }
                      }
                    : null,
                heroTag: "create_route",
                label: const Text("Create Route"),
                icon: const Icon(Icons.route),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRouteCreatedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            "🚀 Route created! Use 'Launch Rocket' button to start animation"),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
