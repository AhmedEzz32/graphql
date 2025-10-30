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
  final double? userLatitude;
  final double? userLongitude;

  const SearchPlaces({
    required this.query,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  List<Object?> get props => [query, userLatitude, userLongitude];
}

class SearchLaunchViewingLocations extends MapEvent {
  final double launchSiteLatitude;
  final double launchSiteLongitude;
  final double? userLatitude;
  final double? userLongitude;

  const SearchLaunchViewingLocations({
    required this.launchSiteLatitude,
    required this.launchSiteLongitude,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  List<Object?> get props => [
        launchSiteLatitude,
        launchSiteLongitude,
        userLatitude,
        userLongitude,
      ];
}

class LoadConstantMapData extends MapEvent {
  const LoadConstantMapData();
}

class SelectPlace extends MapEvent {
  final double latitude;
  final double longitude;
  final String placeName;

  const SelectPlace({
    required this.latitude,
    required this.longitude,
    required this.placeName,
  });

  @override
  List<Object?> get props => [latitude, longitude, placeName];
}
