import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'space_map_event.dart';
import 'space_map_state.dart';

class SpaceMapBloc extends Bloc<SpaceMapEvent, SpaceMapState> {
  Timer? _animationTimer;

  SpaceMapBloc() : super(const SpaceMapInitial()) {
    on<LoadRocketIcon>(_onLoadRocketIcon);
    on<LoadDestinationIcon>(_onLoadDestinationIcon);
    on<RocketIconLoaded>(_onRocketIconLoaded);
    on<MapTapped>(_onMapTapped);
    on<ClearMap>(_onClearMap);
    on<CreateCurvedRoute>(_onCreateCurvedRoute);
    on<StartRocketAnimation>(_onStartRocketAnimation);
    on<UpdateRocketPosition>(_onUpdateRocketPosition);
    on<RocketReachedDestination>(_onRocketReachedDestination);
  }

  @override
  Future<void> close() {
    _animationTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadRocketIcon(
    LoadRocketIcon event,
    Emitter<SpaceMapState> emit,
  ) async {
    try {
      final rocketIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(32, 32)),
        'assets/icons/rocket.png',
      );
      add(RocketIconLoaded(rocketIcon));
    } catch (e) {
      final rocketIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      add(RocketIconLoaded(rocketIcon));
      debugPrint('Failed to load rocket icon: $e');
    }
  }

  Future<void> _onLoadDestinationIcon(
    LoadDestinationIcon event,
    Emitter<SpaceMapState> emit,
  ) async {
    try {
      final destinationIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 40)),
        'assets/icons/rocket.png',
      );
      add(DestinationIconLoaded(destinationIcon));
    } catch (e) {
      final destinationIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      add(DestinationIconLoaded(destinationIcon));
      debugPrint('Failed to load destination reached icon: $e');
    }
  }

  void _onRocketIconLoaded(
    RocketIconLoaded event,
    Emitter<SpaceMapState> emit,
  ) {
    if (state is SpaceMapLoaded) {
      final currentState = state as SpaceMapLoaded;
      emit(currentState.copyWith(
        rocketIcon: event.rocketIcon,
        iconLoaded: true,
      ));
    } else {
      emit(SpaceMapLoaded(
        rocketIcon: event.rocketIcon,
        iconLoaded: true,
      ));
    }
  }

  void _onMapTapped(
    MapTapped event,
    Emitter<SpaceMapState> emit,
  ) {
    if (state is! SpaceMapLoaded) return;

    final currentState = state as SpaceMapLoaded;
    final Set<Marker> newMarkers = Set.from(currentState.markers);

    if (currentState.origin == null) {
      // Set origin
      newMarkers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: event.tappedPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: const InfoWindow(title: 'Launch Pad'),
        ),
      );
      emit(currentState.copyWith(
        origin: event.tappedPoint,
        markers: newMarkers,
      ));
    } else if (currentState.destination == null) {
      // Set destination
      newMarkers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: event.tappedPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Target'),
        ),
      );
      emit(currentState.copyWith(
        destination: event.tappedPoint,
        markers: newMarkers,
      ));
    }
  }

  void _onClearMap(
    ClearMap event,
    Emitter<SpaceMapState> emit,
  ) {
    _animationTimer?.cancel();

    if (state is SpaceMapLoaded) {
      final currentState = state as SpaceMapLoaded;
      emit(currentState.copyWith(
        markers: <Marker>{},
        polylines: <Polyline>{},
        isAnimating: false,
        clearOrigin: true,
        clearDestination: true,
        clearCurvePoints: true,
        clearRocketPosition: true,
      ));
    }
  }

  void _onCreateCurvedRoute(
    CreateCurvedRoute event,
    Emitter<SpaceMapState> emit,
  ) {
    if (state is! SpaceMapLoaded) return;

    final currentState = state as SpaceMapLoaded;
    final List<LatLng> curvePoints = [];

    const double offset = 0.6;

    final double midLat =
        (event.origin.latitude + event.destination.latitude) / 2;
    final double midLng =
        (event.origin.longitude + event.destination.longitude) / 2;
    final double dx = event.destination.longitude - event.origin.longitude;
    final double dy = event.destination.latitude - event.origin.latitude;
    final double d = sqrt(dx * dx + dy * dy);
    final double nx = -dy / d;
    final double ny = dx / d;

    final LatLng controlPoint = LatLng(
      midLat + offset * ny,
      midLng + offset * nx,
    );

    for (double t = 0; t <= 1; t += 0.02) {
      final double lat = (1 - t) * (1 - t) * event.origin.latitude +
          2 * (1 - t) * t * controlPoint.latitude +
          t * t * event.destination.latitude;
      final double lng = (1 - t) * (1 - t) * event.origin.longitude +
          2 * (1 - t) * t * controlPoint.longitude +
          t * t * event.destination.longitude;
      curvePoints.add(LatLng(lat, lng));
    }

    final Set<Polyline> newPolylines = Set.from(currentState.polylines);
    newPolylines.clear();
    newPolylines.add(
      Polyline(
        polylineId: const PolylineId("curved_route"),
        color: Colors.lightBlueAccent,
        width: 6,
        points: curvePoints,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );

    emit(currentState.copyWith(
      polylines: newPolylines,
      curvePoints: curvePoints,
    ));
  }

  void _onStartRocketAnimation(
    StartRocketAnimation event,
    Emitter<SpaceMapState> emit,
  ) {
    if (state is! SpaceMapLoaded) return;

    final currentState = state as SpaceMapLoaded;

    if (currentState.curvePoints.isEmpty || currentState.isAnimating) return;

    final Set<Marker> newMarkers = Set.from(currentState.markers);
    newMarkers.removeWhere((marker) => marker.markerId.value == 'rocket');

    emit(currentState.copyWith(
      isAnimating: true,
      markers: newMarkers,
    ));

    _startAnimation(currentState.curvePoints);
  }

  void _startAnimation(List<LatLng> curvePoints) {
    int currentIndex = 0;
    const Duration stepDuration = Duration(milliseconds: 250);

    _animationTimer = Timer.periodic(stepDuration, (timer) {
      if (currentIndex >= curvePoints.length) {
        timer.cancel();
        add(const RocketReachedDestination());
        return;
      }

      final currentPosition = curvePoints[currentIndex];
      double rotation = 0.0;

      if (currentIndex < curvePoints.length - 1) {
        final nextPosition = curvePoints[currentIndex + 1];
        rotation = _calculateBearing(currentPosition, nextPosition);
      }

      final int progress = ((currentIndex / curvePoints.length) * 100).toInt();

      add(UpdateRocketPosition(
        position: currentPosition,
        rotation: rotation,
        progress: progress,
      ));

      currentIndex++;
    });
  }

  void _onUpdateRocketPosition(
    UpdateRocketPosition event,
    Emitter<SpaceMapState> emit,
  ) {
    if (state is! SpaceMapLoaded) return;

    final currentState = state as SpaceMapLoaded;
    final Set<Marker> newMarkers = Set.from(currentState.markers);

    // Remove existing rocket marker
    newMarkers.removeWhere((marker) => marker.markerId.value == 'rocket');

    // Add updated rocket marker
    newMarkers.add(
      Marker(
        markerId: const MarkerId('rocket'),
        position: event.position,
        icon: currentState.rocketIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        rotation: event.rotation,
        infoWindow: InfoWindow(
          title: '🚀 Rocket',
          snippet: 'Progress: ${event.progress}%',
        ),
      ),
    );

    emit(currentState.copyWith(
      markers: newMarkers,
      currentRocketPosition: event.position,
      rocketRotation: event.rotation,
      animationProgress: event.progress,
    ));
  }

  void _onRocketReachedDestination(
    RocketReachedDestination event,
    Emitter<SpaceMapState> emit,
  ) {
    if (state is! SpaceMapLoaded) return;

    final currentState = state as SpaceMapLoaded;
    final Set<Marker> newMarkers = Set.from(currentState.markers);

    newMarkers.removeWhere((marker) => marker.markerId.value == 'rocket');

    if (currentState.destination != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('rocket_arrived'),
          position: currentState.destination!,
          icon: currentState.destinationIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(
            title: '🎯 Mission Complete!',
            snippet: 'Rocket has successfully reached its destination',
          ),
        ),
      );
    }

    emit(currentState.copyWith(
      isAnimating: false,
      markers: newMarkers,
      clearRocketPosition: true,
    ));
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final double lat1Rad = start.latitude * pi / 180;
    final double lat2Rad = end.latitude * pi / 180;
    final double deltaLngRad = (end.longitude - start.longitude) * pi / 180;

    final double y = sin(deltaLngRad) * cos(lat2Rad);
    final double x = cos(lat1Rad) * sin(lat2Rad) -
        sin(lat1Rad) * cos(lat2Rad) * cos(deltaLngRad);

    final double bearingRad = atan2(y, x);
    final double bearingDeg = bearingRad * 180 / pi;

    // Convert to 0-360 range and adjust for marker rotation
    return (bearingDeg + 360) % 360;
  }
}
