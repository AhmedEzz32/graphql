import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMapData extends MapEvent {

  final int limit;
  final int offset;
  
  const LoadMapData({
    this.limit = 50,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [limit, offset];
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
