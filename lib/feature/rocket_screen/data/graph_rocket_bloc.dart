import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_information_app/core/errors/failures.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_bloc_state.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_event_bloc.dart';
import 'package:spacex_information_app/core/utils/network/graphql/config/graphql_config.dart';
import 'package:spacex_information_app/core/utils/network/graphql/queries/rocket_queries.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/graphql_rocket_models.dart';

class GraphQLRocketBloc extends Bloc<GraphQLRocketEvent, GraphQLRocketState> {
  GraphQLRocketBloc() : super(const GraphQLRocketInitial()) {
    on<FetchRockets>(_onFetchRockets);
    on<SearchRockets>(_onSearchRockets);
    on<FilterRockets>(_onFilterRockets);
    on<UpdateRocketFilterState>(_onUpdateRocketFilterState);
    on<ClearRocketFilters>(_onClearRocketFilters);
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
          isNetworkError: GraphQLErrorHandler.isNetworkError(result.exception!),
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
          searchQuery: currentState.searchQuery,
          showActive: currentState.showActive,
          showInactive: currentState.showInactive,
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
          isNetworkError: GraphQLErrorHandler.isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> rocketData = result.data?['rockets'] ?? [];
      final List<GraphQLRocket> allRockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

      final String searchTerm = event.searchTerm.toLowerCase();
      final List<GraphQLRocket> filteredRockets = allRockets.where((rocket) {
        return rocket.name.toLowerCase().contains(searchTerm) ||
            rocket.type.toLowerCase().contains(searchTerm) ||
            rocket.description.toLowerCase().contains(searchTerm) ||
            rocket.company.toLowerCase().contains(searchTerm) ||
            rocket.country.toLowerCase().contains(searchTerm);
      }).toList();

      emit(GraphQLRocketsLoaded(
        rockets: filteredRockets,
        searchQuery: event.searchTerm,
      ));
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
          isNetworkError: GraphQLErrorHandler.isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> rocketData = result.data?['rockets'] ?? [];
      List<GraphQLRocket> allRockets =
          rocketData.map((json) => GraphQLRocket.fromJson(json)).toList();

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

      if (event.showActive == true && event.showInactive != true) {
        allRockets =
            allRockets.where((rocket) => rocket.active == true).toList();
      } else if (event.showInactive == true && event.showActive != true) {
        allRockets =
            allRockets.where((rocket) => rocket.active == false).toList();
      }

      emit(GraphQLRocketsLoaded(
        rockets: allRockets,
        searchQuery: event.searchQuery,
        showActive: event.showActive,
        showInactive: event.showInactive,
      ));
    } catch (e) {
      emit(GraphQLRocketError(message: 'An unexpected error occurred: $e'));
    }
  }

  void _onUpdateRocketFilterState(
    UpdateRocketFilterState event,
    Emitter<GraphQLRocketState> emit,
  ) {
    if (state is GraphQLRocketsLoaded) {
      final currentState = state as GraphQLRocketsLoaded;
      emit(currentState.copyWith(
        searchQuery: event.searchQuery,
        showActive: event.showActive,
        showInactive: event.showInactive,
      ));
    }
  }

  void _onClearRocketFilters(
    ClearRocketFilters event,
    Emitter<GraphQLRocketState> emit,
  ) {
    if (state is GraphQLRocketsLoaded) {
      final currentState = state as GraphQLRocketsLoaded;
      emit(currentState.copyWith(
        searchQuery: null,
        showActive: null,
        showInactive: null,
      ));
    }
  }
}
