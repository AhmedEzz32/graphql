import 'dart:async';
import 'dart:math';
import '../models/place_result.dart';
import '../data/constant_map_data.dart';

/// GraphQL-compatible Places API Service using mock data
/// This keeps the app consistent with GraphQL architecture
class PlacesApiService {
  /// Search for places related to launch viewing using mock data
  static Future<List<PlaceResult>> searchLaunchViewingLocations({
    required double latitude,
    required double longitude,
    required double radiusKm,
    String query = 'launch viewing beach park observation',
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final List<PlaceResult> allMockPlaces = _getMockPlaces();
    final List<PlaceResult> filteredPlaces = [];

    // Filter places by distance and query relevance
    for (final place in allMockPlaces) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        place.latitude,
        place.longitude,
      );

      if (distance <= radiusKm) {
        // Add relevance score based on query
        final relevanceScore = _calculateRelevanceScore(place.name, query);
        if (relevanceScore > 0.3) {
          filteredPlaces.add(place.copyWith(rating: relevanceScore * 5));
        }
      }
    }

    // Sort by distance from user location
    filteredPlaces.sort((a, b) {
      final distanceA =
          _calculateDistance(latitude, longitude, a.latitude, a.longitude);
      final distanceB =
          _calculateDistance(latitude, longitude, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB);
    });

    return filteredPlaces.take(20).toList();
  }

  /// Search for observation points near specific launch sites
  static Future<List<PlaceResult>> searchObservationPoints({
    required String launchSiteName,
    double radiusKm = 50.0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Get launch site coordinates
    final launchSites = ConstantMapData.launchSites;
    final targetSite = launchSites.values
        .where((site) =>
            site.name.toLowerCase().contains(launchSiteName.toLowerCase()))
        .firstOrNull;

    if (targetSite == null) {
      return [];
    }

    // Get observation points for this launch site
    final observationPoints = ConstantMapData.getObservationPointsNearLocation(
      targetSite.id,
    );

    return observationPoints
        .map((point) => PlaceResult(
              placeId: 'obs_${point.name.replaceAll(' ', '_').toLowerCase()}',
              name: point.name,
              vicinity:
                  '${point.distance.toStringAsFixed(1)} km from launch site',
              latitude: point.latitude,
              longitude: point.longitude,
              rating: point.visibility * 5, // Convert 0-1 scale to 0-5 rating
              userRatingsTotal: Random().nextInt(500) + 50,
              types: ['tourist_attraction', 'park', 'point_of_interest'],
              priceLevel: 0,
              photoReference: null,
              isRecommendedForLaunchViewing: point.isRecommended,
            ))
        .toList();
  }

  /// Get places with location bias (prioritize closer locations)
  static Future<List<PlaceResult>> searchWithLocationBias({
    required String query,
    required double userLatitude,
    required double userLongitude,
    double radiusKm = 100.0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final results = await searchLaunchViewingLocations(
      latitude: userLatitude,
      longitude: userLongitude,
      radiusKm: radiusKm,
      query: query,
    );

    // Enhanced bias scoring based on user location with detailed calculations
    return results.map((place) {
      final distance = _calculateDistance(
        userLatitude,
        userLongitude,
        place.latitude,
        place.longitude,
      );

      // Multiple bias factors
      final proximityBonus = (radiusKm - distance) / radiusKm;
      final relevanceScore = _calculateRelevanceScore(place.name, query);
      final popularityBonus = place.userRatingsTotal > 1000 ? 0.2 : 0.0;
      final recommendationBonus =
          place.isRecommendedForLaunchViewing ? 0.5 : 0.0;

      // Weighted bias calculation
      final totalBias = (proximityBonus * 0.4) +
          (relevanceScore * 0.3) +
          (popularityBonus * 0.15) +
          (recommendationBonus * 0.15);

      final biasedRating = (place.rating + totalBias).clamp(0.0, 5.0);

      return place.copyWith(
        rating: biasedRating,
        vicinity:
            '${place.vicinity} • ${distance.toStringAsFixed(1)} km away • Bias Score: ${(totalBias * 100).toStringAsFixed(1)}%',
      );
    }).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating)); // Sort by biased rating
  }

  /// Calculate optimal viewing locations with distance-based recommendations
  static Future<List<PlaceResult>> calculateOptimalViewingLocations({
    required double launchSiteLatitude,
    required double launchSiteLongitude,
    required double userLatitude,
    required double userLongitude,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final results = <PlaceResult>[];
    final allPlaces = _getMockPlaces();

    for (final place in allPlaces) {
      final distanceFromLaunch = _calculateDistance(
        launchSiteLatitude,
        launchSiteLongitude,
        place.latitude,
        place.longitude,
      );

      final distanceFromUser = _calculateDistance(
        userLatitude,
        userLongitude,
        place.latitude,
        place.longitude,
      );

      // Optimal viewing distance is typically 10-50km from launch site
      double optimalityScore;
      if (distanceFromLaunch >= 10 && distanceFromLaunch <= 50) {
        optimalityScore = 1.0;
      } else if (distanceFromLaunch < 10) {
        optimalityScore = distanceFromLaunch / 10; // Too close penalty
      } else {
        optimalityScore = 50 / distanceFromLaunch; // Too far penalty
      }

      // Convenience score based on user distance
      final convenienceScore =
          distanceFromUser <= 100 ? (100 - distanceFromUser) / 100 : 0.1;

      final combinedScore = (optimalityScore * 0.7) + (convenienceScore * 0.3);
      final adjustedRating = (place.rating * combinedScore).clamp(0.0, 5.0);

      results.add(place.copyWith(
        rating: adjustedRating,
        vicinity: '${place.vicinity}\n'
            'Launch Distance: ${distanceFromLaunch.toStringAsFixed(1)} km\n'
            'Your Distance: ${distanceFromUser.toStringAsFixed(1)} km\n'
            'Optimality: ${(optimalityScore * 100).toStringAsFixed(0)}%\n'
            'Convenience: ${(convenienceScore * 100).toStringAsFixed(0)}%',
      ));
    }

    return results
      ..sort((a, b) => b.rating.compareTo(a.rating))
      ..take(10).toList();
  }

  /// Calculate distance between two points using Haversine formula
  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Calculate relevance score based on query terms
  static double _calculateRelevanceScore(String placeName, String query) {
    final placeWords = placeName.toLowerCase().split(' ');
    final queryWords = query.toLowerCase().split(' ');

    int matches = 0;
    for (final queryWord in queryWords) {
      for (final placeWord in placeWords) {
        if (placeWord.contains(queryWord) || queryWord.contains(placeWord)) {
          matches++;
          break;
        }
      }
    }

    return matches / queryWords.length;
  }

  /// Mock places data for launch viewing locations
  static List<PlaceResult> _getMockPlaces() {
    return [
      // Kennedy Space Center area
      PlaceResult(
        placeId: 'ksc_visitor_complex',
        name: 'Kennedy Space Center Visitor Complex',
        vicinity: 'Space Commerce Way, Merritt Island, FL',
        latitude: 28.5244,
        longitude: -80.6820,
        rating: 4.8,
        userRatingsTotal: 25000,
        types: ['tourist_attraction', 'museum'],
        priceLevel: 3,
        photoReference: 'mock_photo_1',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'playalinda_beach',
        name: 'Playalinda Beach',
        vicinity: 'Canaveral National Seashore, FL',
        latitude: 28.7326,
        longitude: -80.7774,
        rating: 4.6,
        userRatingsTotal: 3200,
        types: ['natural_feature', 'park'],
        priceLevel: 0,
        photoReference: 'mock_photo_2',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'new_smyrna_beach',
        name: 'New Smyrna Beach',
        vicinity: 'New Smyrna Beach, FL',
        latitude: 29.0258,
        longitude: -80.9270,
        rating: 4.4,
        userRatingsTotal: 1800,
        types: ['natural_feature', 'tourist_attraction'],
        priceLevel: 0,
        photoReference: 'mock_photo_3',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'cocoa_beach_pier',
        name: 'Cocoa Beach Pier',
        vicinity: 'Cocoa Beach, FL',
        latitude: 28.3181,
        longitude: -80.6081,
        rating: 4.3,
        userRatingsTotal: 5500,
        types: ['tourist_attraction', 'point_of_interest'],
        priceLevel: 1,
        photoReference: 'mock_photo_4',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'melbourne_beach',
        name: 'Melbourne Beach',
        vicinity: 'Melbourne Beach, FL',
        latitude: 28.0681,
        longitude: -80.5606,
        rating: 4.5,
        userRatingsTotal: 2100,
        types: ['natural_feature', 'point_of_interest'],
        priceLevel: 0,
        photoReference: 'mock_photo_5',
        isRecommendedForLaunchViewing: true,
      ),
      // Boca Chica area (for Starship launches)
      PlaceResult(
        placeId: 'boca_chica_beach',
        name: 'Boca Chica Beach',
        vicinity: 'Brownsville, TX',
        latitude: 25.9975,
        longitude: -97.1592,
        rating: 4.2,
        userRatingsTotal: 800,
        types: ['natural_feature', 'point_of_interest'],
        priceLevel: 0,
        photoReference: 'mock_photo_6',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'south_padre_island',
        name: 'South Padre Island',
        vicinity: 'South Padre Island, TX',
        latitude: 26.1118,
        longitude: -97.1681,
        rating: 4.4,
        userRatingsTotal: 12000,
        types: ['locality', 'tourist_attraction'],
        priceLevel: 2,
        photoReference: 'mock_photo_7',
        isRecommendedForLaunchViewing: false,
      ),
      // Vandenberg area
      PlaceResult(
        placeId: 'surf_beach',
        name: 'Surf Beach',
        vicinity: 'Lompoc, CA',
        latitude: 34.7369,
        longitude: -120.6068,
        rating: 4.1,
        userRatingsTotal: 450,
        types: ['natural_feature', 'park'],
        priceLevel: 0,
        photoReference: 'mock_photo_8',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'jalama_beach',
        name: 'Jalama Beach County Park',
        vicinity: 'Lompoc, CA',
        latitude: 34.5133,
        longitude: -120.5097,
        rating: 4.7,
        userRatingsTotal: 2800,
        types: ['campground', 'park'],
        priceLevel: 1,
        photoReference: 'mock_photo_9',
        isRecommendedForLaunchViewing: true,
      ),
      // Additional viewing locations
      PlaceResult(
        placeId: 'chasing_epic_viewing_area',
        name: 'Chasing Epic Launch Viewing Area',
        vicinity: 'US-1, Titusville, FL',
        latitude: 28.6753,
        longitude: -80.7949,
        rating: 4.9,
        userRatingsTotal: 1200,
        types: ['tourist_attraction', 'point_of_interest'],
        priceLevel: 0,
        photoReference: 'mock_photo_10',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'space_view_park',
        name: 'Space View Park',
        vicinity: 'Titusville, FL',
        latitude: 28.6117,
        longitude: -80.7975,
        rating: 4.7,
        userRatingsTotal: 3500,
        types: ['park', 'tourist_attraction'],
        priceLevel: 0,
        photoReference: 'mock_photo_11',
        isRecommendedForLaunchViewing: true,
      ),
      PlaceResult(
        placeId: 'canaveral_lighthouse',
        name: 'Cape Canaveral Lighthouse',
        vicinity: 'Cape Canaveral, FL',
        latitude: 28.4619,
        longitude: -80.5444,
        rating: 4.5,
        userRatingsTotal: 890,
        types: ['tourist_attraction', 'landmark'],
        priceLevel: 1,
        photoReference: 'mock_photo_12',
        isRecommendedForLaunchViewing: false,
      ),
    ];
  }
}
