import 'package:equatable/equatable.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/graphql_launch_models.dart';
import 'package:spacex_information_app/feature/map_screen/data/landpad_model.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/graphql_rocket_models.dart';
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
  final List<GraphQLLaunch> launchLocations;
  final List<LandpadModel> landingZones;
  final List<GraphQLRocket> rockets;

  const MapLoaded({
    required this.launchLocations,
    required this.landingZones,
    required this.rockets,
  });

  MapLoaded copyWith({
    List<GraphQLLaunch>? allLocations,
    List<LandpadModel>? filteredLocations,
    FlightTrajectory? currentTrajectory,
    List<ObservationLocation>? observationPoints,
    String? mapStyle,
    double? userLatitude,
    double? userLongitude,
    bool clearTrajectory = false,
  }) {
    return MapLoaded(
      launchLocations: allLocations ?? launchLocations,
      landingZones: filteredLocations ?? landingZones,
      rockets: rockets,
    );
  }

  @override
  List<Object?> get props => [
        launchLocations,
        landingZones,
        rockets,
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
