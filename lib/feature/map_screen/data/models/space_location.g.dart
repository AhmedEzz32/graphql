// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceLocation _$SpaceLocationFromJson(Map<String, dynamic> json) =>
    SpaceLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      type: $enumDecode(_$LocationTypeEnumMap, json['type']),
      region: json['region'] as String,
      isActive: json['isActive'] as bool? ?? true,
      details: json['details'] as String?,
      supportedVehicles: (json['supportedVehicles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SpaceLocationToJson(SpaceLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': _$LocationTypeEnumMap[instance.type]!,
      'region': instance.region,
      'isActive': instance.isActive,
      'details': instance.details,
      'supportedVehicles': instance.supportedVehicles,
    };

const _$LocationTypeEnumMap = {
  LocationType.launchSite: 'launchSite',
  LocationType.landingZone: 'landingZone',
  LocationType.recoveryZone: 'recoveryZone',
  LocationType.droneShip: 'droneShip',
  LocationType.observationPoint: 'observationPoint',
};

TrajectoryPoint _$TrajectoryPointFromJson(Map<String, dynamic> json) =>
    TrajectoryPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      velocity: (json['velocity'] as num).toDouble(),
      timestamp: (json['timestamp'] as num).toInt(),
      phase: json['phase'] as String,
    );

Map<String, dynamic> _$TrajectoryPointToJson(TrajectoryPoint instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'velocity': instance.velocity,
      'timestamp': instance.timestamp,
      'phase': instance.phase,
    };

FlightTrajectory _$FlightTrajectoryFromJson(Map<String, dynamic> json) =>
    FlightTrajectory(
      launchId: json['launchId'] as String,
      missionName: json['missionName'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => TrajectoryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      launchSiteId: json['launchSiteId'] as String,
      landingSiteId: json['landingSiteId'] as String?,
      launchTime: DateTime.parse(json['launchTime'] as String),
    );

Map<String, dynamic> _$FlightTrajectoryToJson(FlightTrajectory instance) =>
    <String, dynamic>{
      'launchId': instance.launchId,
      'missionName': instance.missionName,
      'points': instance.points,
      'launchSiteId': instance.launchSiteId,
      'landingSiteId': instance.landingSiteId,
      'launchTime': instance.launchTime.toIso8601String(),
    };

ObservationLocation _$ObservationLocationFromJson(Map<String, dynamic> json) =>
    ObservationLocation(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
      weatherConditions: json['weatherConditions'] as String,
      isRecommended: json['isRecommended'] as bool,
    );

Map<String, dynamic> _$ObservationLocationToJson(
        ObservationLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'visibility': instance.visibility,
      'weatherConditions': instance.weatherConditions,
      'isRecommended': instance.isRecommended,
    };
