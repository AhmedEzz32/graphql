import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SpaceMapEvent extends Equatable {
  const SpaceMapEvent();

  @override
  List<Object?> get props => [];
}

class LoadRocketIcon extends SpaceMapEvent {
  const LoadRocketIcon();
}

class LoadDestinationIcon extends SpaceMapEvent {
  const LoadDestinationIcon();
}

class RocketIconLoaded extends SpaceMapEvent {
  final BitmapDescriptor? rocketIcon;

  const RocketIconLoaded(this.rocketIcon);

  @override
  List<Object?> get props => [rocketIcon];
}

class DestinationIconLoaded extends SpaceMapEvent {
  final BitmapDescriptor? destinationIcon;

  const DestinationIconLoaded(this.destinationIcon);

  @override
  List<Object?> get props => [destinationIcon];
}

class MapTapped extends SpaceMapEvent {
  final LatLng tappedPoint;

  const MapTapped(this.tappedPoint);

  @override
  List<Object?> get props => [tappedPoint];
}

class ClearMap extends SpaceMapEvent {
  const ClearMap();
}

class CreateCurvedRoute extends SpaceMapEvent {
  final LatLng origin;
  final LatLng destination;

  const CreateCurvedRoute({
    required this.origin,
    required this.destination,
  });

  @override
  List<Object?> get props => [origin, destination];
}

class StartRocketAnimation extends SpaceMapEvent {
  const StartRocketAnimation();
}

class UpdateRocketPosition extends SpaceMapEvent {
  final LatLng position;
  final double rotation;
  final int progress;

  const UpdateRocketPosition({
    required this.position,
    required this.rotation,
    required this.progress,
  });

  @override
  List<Object?> get props => [position, rotation, progress];
}

class RocketReachedDestination extends SpaceMapEvent {
  const RocketReachedDestination();
}
