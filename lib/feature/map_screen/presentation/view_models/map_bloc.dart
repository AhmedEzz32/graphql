import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/mock_space_data_service.dart';
import '../../data/models/space_location.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapInitial()) {
    on<LoadMapData>(_onLoadMapData);
    on<FilterLocationsByType>(_onFilterLocationsByType);
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

      final locations = MockSpaceDataService.getAllLocations();

      final mapStyle = _getSpaceMapStyle();

      double? userLat;
      double? userLng;

      try {
        final permission = await Permission.location.request();
        if (permission.isGranted) {
          final position = await Geolocator.getCurrentPosition();
          userLat = position.latitude;
          userLng = position.longitude;
        }
      } catch (e) {
        e.toString();
      }

      emit(MapLoaded(
        allLocations: locations,
        filteredLocations: locations,
        mapStyle: mapStyle,
        userLatitude: userLat,
        userLongitude: userLng,
      ));
    } catch (e) {
      emit(MapError('Failed to load map data: ${e.toString()}'));
    }
  }

  Future<void> _onFilterLocationsByType(
    FilterLocationsByType event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;

      List<SpaceLocation> filtered;
      if (event.selectedTypes.isEmpty) {
        filtered = currentState.allLocations;
      } else {
        filtered = currentState.allLocations.where((location) {
          return event.selectedTypes.contains(location.type.name);
        }).toList();
      }

      emit(currentState.copyWith(filteredLocations: filtered));
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

  String _getSpaceMapStyle() {
    // Custom space-themed map style JSON
    return '''
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#1a1a2e"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8ec3b9"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1a1a2e"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6cb7"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#64779e"
          }
        ]
      },
      {
        "featureType": "administrative.province",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6cb7"
          }
        ]
      },
      {
        "featureType": "landscape.man_made",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#334e87"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#6f9ba4"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3C7680"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#304a7d"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#2c6675"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#255763"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#b0d5ce"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3a4762"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#0e1626"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#4e6d70"
          }
        ]
      }
    ]
    ''';
  }
}
