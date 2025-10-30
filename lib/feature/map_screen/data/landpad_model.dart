
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'landpad_model.g.dart';

@JsonSerializable()
class LandpadModel extends Equatable {
  final String id;
  @JsonKey(name: 'full_name')
  final String fullName;
  final LocationModel? location;

  const LandpadModel({
    required this.id,
    required this.fullName,
    this.location,
  });

  factory LandpadModel.fromJson(Map<String, dynamic> json) =>
      _$LandpadModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandpadModelToJson(this);

  @override
  List<Object?> get props => [id, fullName, location];
}

@JsonSerializable()
class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String name;
  final String region;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.region,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  @override
  List<Object?> get props => [latitude, longitude, name, region];
}