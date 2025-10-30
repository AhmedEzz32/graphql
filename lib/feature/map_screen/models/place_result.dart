class PlaceResult {
  final String placeId;
  final String name;
  final String vicinity;
  final double latitude;
  final double longitude;
  final double rating;
  final int userRatingsTotal;
  final List<String> types;
  final int? priceLevel;
  final String? photoReference;
  final bool isRecommendedForLaunchViewing;

  const PlaceResult({
    required this.placeId,
    required this.name,
    required this.vicinity,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.userRatingsTotal,
    required this.types,
    this.priceLevel,
    this.photoReference,
    this.isRecommendedForLaunchViewing = false,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];

    return PlaceResult(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      vicinity: json['vicinity'] ?? json['formatted_address'] ?? '',
      latitude: location['lat']?.toDouble() ?? 0.0,
      longitude: location['lng']?.toDouble() ?? 0.0,
      rating: (json['rating']?.toDouble()) ?? 0.0,
      userRatingsTotal: json['user_ratings_total'] ?? 0,
      types: List<String>.from(json['types'] ?? []),
      priceLevel: json['price_level'],
      photoReference: json['photos']?[0]?['photo_reference'],
      isRecommendedForLaunchViewing:
          json['is_recommended_for_launch_viewing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'name': name,
      'vicinity': vicinity,
      'geometry': {
        'location': {
          'lat': latitude,
          'lng': longitude,
        },
      },
      'rating': rating,
      'user_ratings_total': userRatingsTotal,
      'types': types,
      'price_level': priceLevel,
      'photos': photoReference != null
          ? [
              {'photo_reference': photoReference}
            ]
          : null,
      'is_recommended_for_launch_viewing': isRecommendedForLaunchViewing,
    };
  }

  PlaceResult copyWith({
    String? placeId,
    String? name,
    String? vicinity,
    double? latitude,
    double? longitude,
    double? rating,
    int? userRatingsTotal,
    List<String>? types,
    int? priceLevel,
    String? photoReference,
    bool? isRecommendedForLaunchViewing,
  }) {
    return PlaceResult(
      placeId: placeId ?? this.placeId,
      name: name ?? this.name,
      vicinity: vicinity ?? this.vicinity,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      types: types ?? this.types,
      priceLevel: priceLevel ?? this.priceLevel,
      photoReference: photoReference ?? this.photoReference,
      isRecommendedForLaunchViewing:
          isRecommendedForLaunchViewing ?? this.isRecommendedForLaunchViewing,
    );
  }

  @override
  String toString() {
    return 'PlaceResult(placeId: $placeId, name: $name, vicinity: $vicinity, '
        'lat: $latitude, lng: $longitude, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceResult &&
        other.placeId == placeId &&
        other.name == name &&
        other.vicinity == vicinity &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.rating == rating &&
        other.userRatingsTotal == userRatingsTotal &&
        other.isRecommendedForLaunchViewing == isRecommendedForLaunchViewing;
  }

  @override
  int get hashCode {
    return Object.hash(
      placeId,
      name,
      vicinity,
      latitude,
      longitude,
      rating,
      userRatingsTotal,
      isRecommendedForLaunchViewing,
    );
  }
}
