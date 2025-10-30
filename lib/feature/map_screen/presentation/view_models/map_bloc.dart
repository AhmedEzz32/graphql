import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_information_app/core/utils/network/graphql/config/graphql_config.dart';
import 'package:spacex_information_app/core/utils/network/graphql/queries/landpad_queries.dart';
import 'package:spacex_information_app/core/utils/network/graphql/queries/launches_queries.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/graphql_launch_models.dart';
import 'package:spacex_information_app/feature/map_screen/data/landpad_model.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/graphql_rocket_models.dart';
import '../../data/mock_space_data_service.dart';
import '../../data/models/space_location.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapInitial()) {
    on<LoadMapData>(_onLoadMapData);
    on<ShowTrajectory>(_onShowTrajectory);
    on<HideTrajectory>(_onHideTrajectory);
    on<SearchNearbyObservationPoints>(_onSearchNearbyObservationPoints);
    on<UpdateMapStyle>(_onUpdateMapStyle);
    on<UpdateUserLocation>(_onUpdateUserLocation);
    on<SearchPlaces>(_onSearchPlaces);
  }

  Future<void> _onLoadMapData(LoadMapData event, Emitter<MapState> emit) async {
    try {
      emit(const MapLoading());

      final client = GraphQLConfig.clientInstance;
      /// TODO: Modify queries to fetch launching locations, landing zones, and rockets separately
      final QueryOptions launchingOptions = QueryOptions(
        document: gql(GET_UPCOMING_LAUNCHES_QUERY),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );
      final QueryOptions landingOptions = QueryOptions(
        document: gql(GET_LANDPADS_QUERY),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );
      final QueryOptions rocketsOptions = QueryOptions(
        document: gql(GET_ROCKETS_QUERY),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final List<QueryResult> result = await Future.wait<QueryResult>([
        client.query(launchingOptions), /// for launching locations
        client.query(landingOptions), /// for landing zones
        client.query(rocketsOptions), /// for rockets
      ]);

      if (result.any((result) => result.hasException)) {
        final exception = result
            .firstWhere((result) => result.hasException)
            .exception!;
        emit(MapError(
            'Error loading map data: ${_getErrorMessage(exception)}'));
        return;
      }

      final List<dynamic> launchData = result[0].data?['launchesUpcoming'] ?? [];
      final List<GraphQLLaunch> launches =
          launchData.map((json) => GraphQLLaunch.fromJson(json)).toList();

      final List<dynamic> landingData = result[1].data?['landpads'] ?? [];
      final List<LandpadModel> locations =
          landingData.map((json) => LandpadModel.fromJson(json)).toList();
      
      final List<dynamic> rocketData = result[2].data?['rockets'] ?? [];
      final List<GraphQLRocket> rockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

      emit(MapLoaded(
        launchLocations: launches,
        landingZones: locations,
        rockets: rockets,
      ));
    } catch (e) {
      emit(MapError('Failed to load map data: ${e.toString()}'));
    }
  }

  Future<void> _onShowTrajectory(
      ShowTrajectory event, Emitter<MapState> emit) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;

      try {
        final trajectory = MockSpaceDataService.generateMockTrajectory(
          event.launchId,
          'Mission ${event.launchId}',
        );

        emit(currentState.copyWith(currentTrajectory: trajectory));
      } catch (e) {
        emit(MapError('Failed to load trajectory: ${e.toString()}'));
      }
    }
  }

  Future<void> _onHideTrajectory(
      HideTrajectory event, Emitter<MapState> emit) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(clearTrajectory: true));
    }
  }

  Future<void> _onSearchNearbyObservationPoints(
    SearchNearbyObservationPoints event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;

      try {
        final observationPoints = MockSpaceDataService.getObservationPoints(
          event.latitude,
          event.longitude,
          event.launchSiteId,
        );

        emit(currentState.copyWith(observationPoints: observationPoints));
      } catch (e) {
        emit(MapError('Failed to find observation points: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateMapStyle(
      UpdateMapStyle event, Emitter<MapState> emit) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(mapStyle: event.styleJson));
    }
  }

  Future<void> _onUpdateUserLocation(
    UpdateUserLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(
        userLatitude: event.latitude,
        userLongitude: event.longitude,
      ));
    }
  }

  Future<void> _onSearchPlaces(
      SearchPlaces event, Emitter<MapState> emit) async {
    // Mock implementation - in real app, you'd use Google Places API
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final mockResults = [
        'Kennedy Space Center, FL',
        'Cape Canaveral, FL',
        'Vandenberg Space Force Base, CA',
        'Boca Chica, TX',
        'Cocoa Beach, FL',
        'Titusville, FL',
        'New Smyrna Beach, FL',
      ]
          .where((place) =>
              place.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(PlacesSearchResult(mockResults));
    } catch (e) {
      emit(MapError('Failed to search places: ${e.toString()}'));
    }
  }

  String _getErrorMessage(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.first.message;
    }
    if (exception.linkException != null) {
      if (exception.linkException is NetworkException) {
        return 'Network error. Please check your internet connection.';
      }
      if (exception.linkException is ServerException) {
        return 'Server error. Please try again later.';
      }
    }
    return 'An unexpected error occurred.';
  }
}
