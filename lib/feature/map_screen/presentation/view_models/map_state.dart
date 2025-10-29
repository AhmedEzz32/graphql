import 'package:equatable/equatable.dart';
import '../../data/models/space_location.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  final List<SpaceLocation> allLocations;
  final List<SpaceLocation> filteredLocations;
  final FlightTrajectory? currentTrajectory;
  final List<ObservationLocation> observationPoints;
  final String mapStyle;
  final double? userLatitude;
  final double? userLongitude;

  const MapLoaded({
    required this.allLocations,
    required this.filteredLocations,
    this.currentTrajectory,
    this.observationPoints = const [],
    this.mapStyle = '',
    this.userLatitude,
    this.userLongitude,
  });

  MapLoaded copyWith({
    List<SpaceLocation>? allLocations,
    List<SpaceLocation>? filteredLocations,
    FlightTrajectory? currentTrajectory,
    List<ObservationLocation>? observationPoints,
    String? mapStyle,
    double? userLatitude,
    double? userLongitude,
    bool clearTrajectory = false,
  }) {
    return MapLoaded(
      allLocations: allLocations ?? this.allLocations,
      filteredLocations: filteredLocations ?? this.filteredLocations,
      currentTrajectory:
          clearTrajectory ? null : currentTrajectory ?? this.currentTrajectory,
      observationPoints: observationPoints ?? this.observationPoints,
      mapStyle: mapStyle ?? this.mapStyle,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
    );
  }

  @override
  List<Object?> get props => [
        allLocations,
        filteredLocations,
        currentTrajectory,
        observationPoints,
        mapStyle,
        userLatitude,
        userLongitude,
      ];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlacesSearchResult extends MapState {
  final List<String> places;

  const PlacesSearchResult(this.places);

  @override
  List<Object?> get props => [places];
}
