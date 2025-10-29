import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMapData extends MapEvent {
  const LoadMapData();
}

class FilterLocationsByType extends MapEvent {
  final List<String> selectedTypes;

  const FilterLocationsByType(this.selectedTypes);

  @override
  List<Object?> get props => [selectedTypes];
}

class ShowTrajectory extends MapEvent {
  final String launchId;

  const ShowTrajectory(this.launchId);

  @override
  List<Object?> get props => [launchId];
}

class HideTrajectory extends MapEvent {
  const HideTrajectory();
}

class SearchNearbyObservationPoints extends MapEvent {
  final double latitude;
  final double longitude;
  final String launchSiteId;

  const SearchNearbyObservationPoints({
    required this.latitude,
    required this.longitude,
    required this.launchSiteId,
  });

  @override
  List<Object?> get props => [latitude, longitude, launchSiteId];
}

class UpdateMapStyle extends MapEvent {
  final String styleJson;

  const UpdateMapStyle(this.styleJson);

  @override
  List<Object?> get props => [styleJson];
}

class UpdateUserLocation extends MapEvent {
  final double latitude;
  final double longitude;

  const UpdateUserLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class SearchPlaces extends MapEvent {
  final String query;

  const SearchPlaces(this.query);

  @override
  List<Object?> get props => [query];
}
