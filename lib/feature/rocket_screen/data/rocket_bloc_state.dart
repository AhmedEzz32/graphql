import 'package:equatable/equatable.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/graphql_rocket_models.dart';

abstract class GraphQLRocketState extends Equatable {
  const GraphQLRocketState();

  @override
  List<Object?> get props => [];
}

class GraphQLRocketInitial extends GraphQLRocketState {
  const GraphQLRocketInitial();
}

class GraphQLRocketLoading extends GraphQLRocketState {
  const GraphQLRocketLoading();
}

class GraphQLRocketsLoaded extends GraphQLRocketState {
  final List<GraphQLRocket> rockets;
  final bool hasReachedMax;
  final bool isRefreshing;
  final String? searchQuery;
  final bool? showActive;
  final bool? showInactive;

  const GraphQLRocketsLoaded({
    required this.rockets,
    this.hasReachedMax = false,
    this.isRefreshing = false,
    this.searchQuery,
    this.showActive,
    this.showInactive,
  });

  GraphQLRocketsLoaded copyWith({
    List<GraphQLRocket>? rockets,
    bool? hasReachedMax,
    bool? isRefreshing,
    String? searchQuery,
    bool? showActive,
    bool? showInactive,
  }) {
    return GraphQLRocketsLoaded(
      rockets: rockets ?? this.rockets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      searchQuery: searchQuery ?? this.searchQuery,
      showActive: showActive ?? this.showActive,
      showInactive: showInactive ?? this.showInactive,
    );
  }

  @override
  List<Object?> get props => [
        rockets,
        hasReachedMax,
        isRefreshing,
        searchQuery,
        showActive,
        showInactive
      ];
}

class GraphQLRocketDetailsLoaded extends GraphQLRocketState {
  final GraphQLRocket rocket;

  const GraphQLRocketDetailsLoaded(this.rocket);

  @override
  List<Object?> get props => [rocket];
}

class GraphQLRocketError extends GraphQLRocketState {
  final String message;
  final bool isNetworkError;

  const GraphQLRocketError({
    required this.message,
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}
