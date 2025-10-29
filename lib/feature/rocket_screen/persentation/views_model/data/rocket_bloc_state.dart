import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
          message: _getErrorMessage(result.exception!),
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
          message: _getErrorMessage(result.exception!),
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
        variables: {'search': event.searchTerm},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLRocketError(
          message: _getErrorMessage(result.exception!),
          isNetworkError: _isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> rocketData = result.data?['rockets'] ?? [];
      final List<GraphQLRocket> rockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

      emit(GraphQLRocketsLoaded(rockets: rockets));
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
          message: _getErrorMessage(result.exception!),
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

  bool _isNetworkError(OperationException exception) {
    return exception.linkException is NetworkException;
  }
}
