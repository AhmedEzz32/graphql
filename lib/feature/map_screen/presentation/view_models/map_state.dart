import 'package:equatable/equatable.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/graphql_launch_models.dart';
import 'package:spacex_information_app/feature/map_screen/data/landpad_model.dart';
import 'package:spacex_information_app/feature/map_screen/models/place_result.dart';
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
  final List<SpaceLocation> constantLaunchSites;
  final List<SpaceLocation> constantLandingZones;
  final List<SpaceLocation> droneShips;
  final List<ObservationLocation> observationPoints;
  final List<PlaceResult> placesSearchResults;
  final FlightTrajectory? currentTrajectory;
  final String? mapStyle;
  final double? userLatitude;
  final double? userLongitude;
  final double? selectedPlaceLatitude;
  final double? selectedPlaceLongitude;
  final String? selectedPlaceName;
  final bool showRouteToSelectedPlace;

  const MapLoaded({
    required this.launchLocations,
    required this.landingZones,
    required this.rockets,
    this.constantLaunchSites = const [],
    this.constantLandingZones = const [],
    this.droneShips = const [],
    this.observationPoints = const [],
    this.placesSearchResults = const [],
    this.currentTrajectory,
    this.mapStyle,
    this.userLatitude,
    this.userLongitude,
    this.selectedPlaceLatitude,
    this.selectedPlaceLongitude,
    this.selectedPlaceName,
    this.showRouteToSelectedPlace = false,
  });

  MapLoaded copyWith({
    List<GraphQLLaunch>? launchLocations,
    List<LandpadModel>? landingZones,
    List<GraphQLRocket>? rockets,
    List<SpaceLocation>? constantLaunchSites,
    List<SpaceLocation>? constantLandingZones,
    List<SpaceLocation>? droneShips,
    List<ObservationLocation>? observationPoints,
    List<PlaceResult>? placesSearchResults,
    FlightTrajectory? currentTrajectory,
    String? mapStyle,
    double? userLatitude,
    double? userLongitude,
    double? selectedPlaceLatitude,
    double? selectedPlaceLongitude,
    String? selectedPlaceName,
    bool? showRouteToSelectedPlace,
    bool clearTrajectory = false,
    bool clearObservationPoints = false,
    bool clearPlacesSearch = false,
    bool clearSelectedPlace = false,
  }) {
    return MapLoaded(
      launchLocations: launchLocations ?? this.launchLocations,
      landingZones: landingZones ?? this.landingZones,
      rockets: rockets ?? this.rockets,
      constantLaunchSites: constantLaunchSites ?? this.constantLaunchSites,
      constantLandingZones: constantLandingZones ?? this.constantLandingZones,
      droneShips: droneShips ?? this.droneShips,
      observationPoints: clearObservationPoints
          ? []
          : (observationPoints ?? this.observationPoints),
      placesSearchResults: clearPlacesSearch
          ? []
          : (placesSearchResults ?? this.placesSearchResults),
      currentTrajectory: clearTrajectory
          ? null
          : (currentTrajectory ?? this.currentTrajectory),
      mapStyle: mapStyle ?? this.mapStyle,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      selectedPlaceLatitude: clearSelectedPlace
          ? null
          : (selectedPlaceLatitude ?? this.selectedPlaceLatitude),
      selectedPlaceLongitude: clearSelectedPlace
          ? null
          : (selectedPlaceLongitude ?? this.selectedPlaceLongitude),
      selectedPlaceName: clearSelectedPlace
          ? null
          : (selectedPlaceName ?? this.selectedPlaceName),
      showRouteToSelectedPlace: clearSelectedPlace
          ? false
          : (showRouteToSelectedPlace ?? this.showRouteToSelectedPlace),
    );
  }

  @override
  List<Object?> get props => [
        launchLocations,
        landingZones,
        rockets,
        constantLaunchSites,
        constantLandingZones,
        droneShips,
        observationPoints,
        placesSearchResults,
        currentTrajectory,
        mapStyle,
        userLatitude,
        userLongitude,
        selectedPlaceLatitude,
        selectedPlaceLongitude,
        selectedPlaceName,
        showRouteToSelectedPlace,
      ];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlacesSearchResult extends MapState {
  final List<PlaceResult> places;

  const PlacesSearchResult(this.places);

  @override
  List<Object?> get props => [places];
}
