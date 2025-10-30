// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landpad_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandpadModel _$LandpadModelFromJson(Map<String, dynamic> json) => LandpadModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LandpadModelToJson(LandpadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'location': instance.location,
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String,
      region: json['region'] as String,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'name': instance.name,
      'region': instance.region,
    };
