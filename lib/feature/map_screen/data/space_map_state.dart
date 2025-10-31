import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SpaceMapState extends Equatable {
  const SpaceMapState();

  @override
  List<Object?> get props => [];
}

class SpaceMapInitial extends SpaceMapState {
  const SpaceMapInitial();
}

class SpaceMapLoaded extends SpaceMapState {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final LatLng? origin;
  final LatLng? destination;
  final List<LatLng> curvePoints;
  final bool isAnimating;
  final bool iconLoaded;
  final BitmapDescriptor? rocketIcon;
  final BitmapDescriptor? destinationIcon;
  final LatLng? currentRocketPosition;
  final double? rocketRotation;
  final int? animationProgress;

  const SpaceMapLoaded({
    this.markers = const {},
    this.polylines = const {},
    this.origin,
    this.destination,
    this.curvePoints = const [],
    this.isAnimating = false,
    this.iconLoaded = false,
    this.rocketIcon,
    this.destinationIcon,
    this.currentRocketPosition,
    this.rocketRotation,
    this.animationProgress,
  });

  SpaceMapLoaded copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    LatLng? origin,
    LatLng? destination,
    List<LatLng>? curvePoints,
    bool? isAnimating,
    bool? iconLoaded,
    BitmapDescriptor? rocketIcon,
    BitmapDescriptor? destinationIcon,
    LatLng? currentRocketPosition,
    double? rocketRotation,
    int? animationProgress,
    bool clearOrigin = false,
    bool clearDestination = false,
    bool clearCurvePoints = false,
    bool clearRocketPosition = false,
  }) {
    return SpaceMapLoaded(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      origin: clearOrigin ? null : (origin ?? this.origin),
      destination: clearDestination ? null : (destination ?? this.destination),
      curvePoints: clearCurvePoints ? [] : (curvePoints ?? this.curvePoints),
      isAnimating: isAnimating ?? this.isAnimating,
      iconLoaded: iconLoaded ?? this.iconLoaded,
      rocketIcon: rocketIcon ?? this.rocketIcon,
      destinationIcon: destinationIcon ?? this.destinationIcon,
      currentRocketPosition: clearRocketPosition
          ? null
          : (currentRocketPosition ?? this.currentRocketPosition),
      rocketRotation: rocketRotation ?? this.rocketRotation,
      animationProgress: animationProgress ?? this.animationProgress,
    );
  }

  @override
  List<Object?> get props => [
        markers,
        polylines,
        origin,
        destination,
        curvePoints,
        isAnimating,
        iconLoaded,
        rocketIcon,
        destinationIcon,
        currentRocketPosition,
        rocketRotation,
        animationProgress,
      ];
}

class SpaceMapError extends SpaceMapState {
  final String message;

  const SpaceMapError(this.message);

  @override
  List<Object?> get props => [message];
}
