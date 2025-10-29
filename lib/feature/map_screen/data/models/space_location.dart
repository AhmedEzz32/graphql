import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'space_location.g.dart';

enum LocationType {
  launchSite,
  landingZone,
  recoveryZone,
  droneShip,
  observationPoint
}

@JsonSerializable()
class SpaceLocation extends Equatable {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final LocationType type;
  final String region;
  final bool isActive;
  final String? details;
  final List<String>? supportedVehicles;

  const SpaceLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.region,
    this.isActive = true,
    this.details,
    this.supportedVehicles,
  });

  factory SpaceLocation.fromJson(Map<String, dynamic> json) =>
      _$SpaceLocationFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceLocationToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        latitude,
        longitude,
        type,
        region,
        isActive,
        details,
        supportedVehicles,
      ];
}

@JsonSerializable()
class TrajectoryPoint extends Equatable {
  final double latitude;
  final double longitude;
  final double altitude;
  final double velocity;
  final int timestamp;
  final String phase;

  const TrajectoryPoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.velocity,
    required this.timestamp,
    required this.phase,
  });

  factory TrajectoryPoint.fromJson(Map<String, dynamic> json) =>
      _$TrajectoryPointFromJson(json);

  Map<String, dynamic> toJson() => _$TrajectoryPointToJson(this);

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        altitude,
        velocity,
        timestamp,
        phase,
      ];
}

@JsonSerializable()
class FlightTrajectory extends Equatable {
  final String launchId;
  final String missionName;
  final List<TrajectoryPoint> points;
  final String launchSiteId;
  final String? landingSiteId;
  final DateTime launchTime;

  const FlightTrajectory({
    required this.launchId,
    required this.missionName,
    required this.points,
    required this.launchSiteId,
    this.landingSiteId,
    required this.launchTime,
  });

  factory FlightTrajectory.fromJson(Map<String, dynamic> json) =>
      _$FlightTrajectoryFromJson(json);

  Map<String, dynamic> toJson() => _$FlightTrajectoryToJson(this);

  @override
  List<Object?> get props => [
        launchId,
        missionName,
        points,
        launchSiteId,
        landingSiteId,
        launchTime,
      ];
}

@JsonSerializable()
class ObservationLocation extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final double distance; // distance from launch site in km
  final double visibility; // 0-1 scale
  final String weatherConditions;
  final bool isRecommended;

  const ObservationLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.visibility,
    required this.weatherConditions,
    required this.isRecommended,
  });

  factory ObservationLocation.fromJson(Map<String, dynamic> json) =>
      _$ObservationLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ObservationLocationToJson(this);

  @override
  List<Object?> get props => [
        name,
        latitude,
        longitude,
        distance,
        visibility,
        weatherConditions,
        isRecommended,
      ];
}
