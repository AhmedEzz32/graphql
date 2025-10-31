// States
import 'package:equatable/equatable.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/graphql_launch_models.dart';

abstract class GraphQLLaunchState extends Equatable {
  const GraphQLLaunchState();

  @override
  List<Object?> get props => [];
}

class GraphQLLaunchInitial extends GraphQLLaunchState {
  const GraphQLLaunchInitial();
}

class GraphQLLaunchLoading extends GraphQLLaunchState {
  const GraphQLLaunchLoading();
}

class GraphQLLaunchesLoaded extends GraphQLLaunchState {
  final List<GraphQLLaunch> launches;
  final bool hasReachedMax;
  final bool isRefreshing;
  final String? currentFilter;
  final String? searchQuery;
  final bool? showPast;
  final bool? showUpcoming;

  const GraphQLLaunchesLoaded({
    required this.launches,
    this.hasReachedMax = false,
    this.isRefreshing = false,
    this.currentFilter,
    this.searchQuery,
    this.showPast,
    this.showUpcoming,
  });

  GraphQLLaunchesLoaded copyWith({
    List<GraphQLLaunch>? launches,
    bool? hasReachedMax,
    bool? isRefreshing,
    String? currentFilter,
    String? searchQuery,
    bool? showPast,
    bool? showUpcoming,
  }) {
    return GraphQLLaunchesLoaded(
      launches: launches ?? this.launches,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentFilter: currentFilter ?? this.currentFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      showPast: showPast ?? this.showPast,
      showUpcoming: showUpcoming ?? this.showUpcoming,
    );
  }

  @override
  List<Object?> get props => [
        launches,
        hasReachedMax,
        isRefreshing,
        currentFilter,
        searchQuery,
        showPast,
        showUpcoming
      ];
}

class GraphQLLaunchDetailsLoaded extends GraphQLLaunchState {
  final GraphQLLaunch launch;

  const GraphQLLaunchDetailsLoaded(this.launch);

  @override
  List<Object?> get props => [launch];
}

class GraphQLLaunchError extends GraphQLLaunchState {
  final String message;
  final bool isNetworkError;

  const GraphQLLaunchError({
    required this.message,
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}
