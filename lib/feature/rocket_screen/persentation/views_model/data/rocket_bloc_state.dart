import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_information_app/core/errors/failures.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/data/rocket_event_bloc.dart';
import 'package:spacex_information_app/core/utils/network/graphql/config/graphql_config.dart';
import 'package:spacex_information_app/core/utils/network/graphql/queries/rocket_queries.dart';
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

  const GraphQLRocketsLoaded({
    required this.rockets,
    this.hasReachedMax = false,
    this.isRefreshing = false,
  });

  GraphQLRocketsLoaded copyWith({
    List<GraphQLRocket>? rockets,
    bool? hasReachedMax,
    bool? isRefreshing,
  }) {
    return GraphQLRocketsLoaded(
      rockets: rockets ?? this.rockets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [rockets, hasReachedMax, isRefreshing];
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

class GraphQLRocketBloc extends Bloc<GraphQLRocketEvent, GraphQLRocketState> {
  GraphQLRocketBloc() : super(const GraphQLRocketInitial()) {
    on<FetchRockets>(_onFetchRockets);
    on<FetchRocketDetails>(_onFetchRocketDetails);
    on<SearchRockets>(_onSearchRockets);
    on<FilterRockets>(_onFilterRockets);
    on<RefreshRockets>(_onRefreshRockets);
  }

  Future<void> _onFetchRockets(
    FetchRockets event,
    Emitter<GraphQLRocketState> emit,
  ) async {
    try {
      if (state is GraphQLRocketInitial) {
        emit(const GraphQLRocketLoading());
      }

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(GET_ROCKETS_QUERY),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLRocketError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: _isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> rocketData = result.data?['rockets'] ?? [];
      final List<GraphQLRocket> rockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

      if (state is GraphQLRocketsLoaded) {
        final currentState = state as GraphQLRocketsLoaded;
        final allRockets = [...currentState.rockets, ...rockets];
        emit(GraphQLRocketsLoaded(
          rockets: allRockets,
          hasReachedMax: rockets.length < event.limit,
        ));
      } else {
        emit(GraphQLRocketsLoaded(
          rockets: rockets,
          hasReachedMax: rockets.length < event.limit,
        ));
      }
    } catch (e) {
      emit(GraphQLRocketError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onFetchRocketDetails(
    FetchRocketDetails event,
    Emitter<GraphQLRocketState> emit,
  ) async {
    try {
      emit(const GraphQLRocketLoading());

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(GET_ROCKET_DETAILS_QUERY),
        variables: {'id': event.rocketId},
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLRocketError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: _isNetworkError(result.exception!),
        ));
        return;
      }

      final Map<String, dynamic>? rocketData = result.data?['rocket'];
      if (rocketData != null) {
        final GraphQLRocket rocket = GraphQLRocket.fromJson(rocketData);
        emit(GraphQLRocketDetailsLoaded(rocket));
      } else {
        emit(const GraphQLRocketError(message: 'Rocket not found'));
      }
    } catch (e) {
      emit(GraphQLRocketError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onSearchRockets(
    SearchRockets event,
    Emitter<GraphQLRocketState> emit,
  ) async {
    try {
      emit(const GraphQLRocketLoading());

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(SEARCH_ROCKETS_QUERY),
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLRocketError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: _isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> rocketData = result.data?['rockets'] ?? [];
      final List<GraphQLRocket> allRockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

      // Client-side filtering
      final String searchTerm = event.searchTerm.toLowerCase();
      final List<GraphQLRocket> filteredRockets = allRockets.where((rocket) {
        return rocket.name.toLowerCase().contains(searchTerm) ||
            rocket.type.toLowerCase().contains(searchTerm) ||
            rocket.description.toLowerCase().contains(searchTerm) ||
            rocket.company.toLowerCase().contains(searchTerm) ||
            rocket.country.toLowerCase().contains(searchTerm);
      }).toList();

      emit(GraphQLRocketsLoaded(rockets: filteredRockets));
    } catch (e) {
      emit(GraphQLRocketError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onFilterRockets(
    FilterRockets event,
    Emitter<GraphQLRocketState> emit,
  ) async {
    try {
      emit(const GraphQLRocketLoading());

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(GET_ROCKETS_QUERY),
        variables: {
          'limit': 50,
          'offset': 0,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLRocketError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: _isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> rocketData = result.data?['rockets'] ?? [];
      List<GraphQLRocket> allRockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

      // Apply search filter if provided
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        final searchQuery = event.searchQuery!.toLowerCase();
        allRockets = allRockets.where((rocket) {
          return rocket.name.toLowerCase().contains(searchQuery) ||
              rocket.type.toLowerCase().contains(searchQuery) ||
              rocket.description.toLowerCase().contains(searchQuery) ||
              rocket.company.toLowerCase().contains(searchQuery) ||
              rocket.country.toLowerCase().contains(searchQuery);
        }).toList();
      }

      // Apply active/inactive filter if provided
      if (event.showActive == true && event.showInactive != true) {
        allRockets =
            allRockets.where((rocket) => rocket.active == true).toList();
      } else if (event.showInactive == true && event.showActive != true) {
        allRockets =
            allRockets.where((rocket) => rocket.active == false).toList();
      }

      emit(GraphQLRocketsLoaded(rockets: allRockets));
    } catch (e) {
      emit(GraphQLRocketError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onRefreshRockets(
    RefreshRockets event,
    Emitter<GraphQLRocketState> emit,
  ) async {
    try {
      if (state is GraphQLRocketsLoaded) {
        final currentState = state as GraphQLRocketsLoaded;
        emit(currentState.copyWith(isRefreshing: true));
      }

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(GET_ROCKETS_QUERY),
        variables: {
          'limit': 10,
          'offset': 0,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLRocketError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: _isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> rocketData = result.data?['rockets'] ?? [];
      final List<GraphQLRocket> rockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

      emit(GraphQLRocketsLoaded(
        rockets: rockets,
        hasReachedMax: rockets.length < 10,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(GraphQLRocketError(message: 'An unexpected error occurred: $e'));
    }
  }

  bool _isNetworkError(OperationException exception) {
    return exception.linkException is NetworkException;
  }
}
