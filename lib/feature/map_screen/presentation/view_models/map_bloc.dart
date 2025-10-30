import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/map_screen/data/constant_map_data.dart';
import 'package:spacex_information_app/feature/map_screen/services/places_api_service.dart';
import 'package:spacex_information_app/feature/map_screen/models/place_result.dart';
import '../../data/mock_space_data_service.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapInitial()) {
    on<LoadConstantMapData>(_onLoadConstantMapData);
    on<ShowTrajectory>(_onShowTrajectory);
    on<HideTrajectory>(_onHideTrajectory);
    on<SearchLaunchViewingLocations>(_onSearchLaunchViewingLocations);
    on<SearchPlaces>(_onSearchPlaces);
    on<SelectPlace>(_onSelectPlace);
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

  Future<void> _onSearchPlaces(
      SearchPlaces event, Emitter<MapState> emit) async {
    // If we're not in MapLoaded state, we can't handle search
    if (state is! MapLoaded) {
      return;
    }

    final currentState = state as MapLoaded;

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Create mock PlaceResult objects instead of strings
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
          .map((place) => PlaceResult(
                placeId: place
                    .toLowerCase()
                    .replaceAll(' ', '_')
                    .replaceAll(',', ''),
                name: place,
                vicinity: place,
                latitude: 28.5, // Mock coordinates
                longitude: -80.6,
                rating: 4.5,
                userRatingsTotal: 100,
                types: ['tourist_attraction'],
              ))
          .toList();

      // Update the existing MapLoaded state with search results
      // instead of emitting a separate PlacesSearchResult state
      emit(currentState.copyWith(placesSearchResults: mockResults));
    } catch (e) {
      emit(MapError('Failed to search places: ${e.toString()}'));
    }
  }

  Future<void> _onLoadConstantMapData(
    LoadConstantMapData event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(const MapLoading());

      // Load constant data only
      emit(MapLoaded(
        launchLocations: const [],
        landingZones: const [],
        rockets: const [],
        constantLaunchSites: ConstantMapData.getAllLaunchSites(),
        constantLandingZones: ConstantMapData.getAllLandingZones(),
        droneShips: ConstantMapData.getAllDroneShips(),
        observationPoints: ConstantMapData.getAllObservationPoints(),
      ));
    } catch (e) {
      emit(MapError('Failed to load constant map data: ${e.toString()}'));
    }
  }

  Future<void> _onSearchLaunchViewingLocations(
    SearchLaunchViewingLocations event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;

      try {
        final places = await PlacesApiService.searchObservationPoints(
          launchSiteName: 'LC-39A',
          radiusKm: 50.0,
        );

        emit(currentState.copyWith(placesSearchResults: places));
      } catch (e) {
        // Fallback to constant observation points if API fails
        final constantObservationPoints =
            ConstantMapData.getAllObservationPoints();
        emit(currentState.copyWith(
            observationPoints: constantObservationPoints));
      }
    }
  }

  Future<void> _onSelectPlace(
    SelectPlace event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;

      // Update the map state with the selected place coordinates and enable polyline
      emit(currentState.copyWith(
        selectedPlaceLatitude: event.latitude,
        selectedPlaceLongitude: event.longitude,
        selectedPlaceName: event.placeName,
        showRouteToSelectedPlace: true,
      ));
    }
  }
}
