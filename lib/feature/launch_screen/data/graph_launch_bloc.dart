import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_information_app/core/errors/failures.dart';
import 'package:spacex_information_app/core/utils/network/graphql/config/graphql_config.dart';
import 'package:spacex_information_app/core/utils/network/graphql/queries/launches_queries.dart';
import 'package:spacex_information_app/feature/launch_screen/data/launch_event_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/data/launch_state_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/graphql_launch_models.dart';

class GraphQLLaunchBloc extends Bloc<GraphQLLaunchEvent, GraphQLLaunchState> {
  GraphQLLaunchBloc() : super(const GraphQLLaunchInitial()) {
    on<FetchLaunches>(_onFetchLaunches);
    on<FetchPastLaunches>(_onFetchPastLaunches);
    on<FetchUpcomingLaunches>(_onFetchUpcomingLaunches);
    on<FilterLaunches>(_onFilterLaunches);
    on<UpdateFilterState>(_onUpdateFilterState);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onFetchLaunches(
    FetchLaunches event,
    Emitter<GraphQLLaunchState> emit,
  ) async {
    try {
      if (state is GraphQLLaunchInitial) {
        emit(const GraphQLLaunchLoading());
      }

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(GET_LAUNCHES_QUERY),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
          if (event.sort != null) 'sort': event.sort,
          if (event.order != null) 'order': event.order,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLLaunchError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: GraphQLErrorHandler.isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> launchData = result.data?['launches'] ?? [];
      final List<GraphQLLaunch> launches =
          launchData.map((json) => GraphQLLaunch.fromJson(json)).toList();

      if (state is GraphQLLaunchesLoaded) {
        final currentState = state as GraphQLLaunchesLoaded;
        final allLaunches = [...currentState.launches, ...launches];
        emit(GraphQLLaunchesLoaded(
          launches: allLaunches,
          hasReachedMax: launches.length < event.limit,
        ));
      } else {
        emit(GraphQLLaunchesLoaded(
          launches: launches,
          hasReachedMax: launches.length < event.limit,
        ));
      }
    } catch (e) {
      emit(GraphQLLaunchError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onFetchPastLaunches(
    FetchPastLaunches event,
    Emitter<GraphQLLaunchState> emit,
  ) async {
    try {
      if (state is GraphQLLaunchInitial) {
        emit(const GraphQLLaunchLoading());
      }

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(GET_PAST_LAUNCHES_QUERY),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLLaunchError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: GraphQLErrorHandler.isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> launchData = result.data?['launchesPast'] ?? [];
      final List<GraphQLLaunch> launches =
          launchData.map((json) => GraphQLLaunch.fromJson(json)).toList();

      if (state is GraphQLLaunchesLoaded) {
        final currentState = state as GraphQLLaunchesLoaded;
        final allLaunches = [...currentState.launches, ...launches];
        emit(GraphQLLaunchesLoaded(
          launches: allLaunches,
          hasReachedMax: launches.length < event.limit,
          currentFilter: 'past',
        ));
      } else {
        emit(GraphQLLaunchesLoaded(
          launches: launches,
          hasReachedMax: launches.length < event.limit,
          currentFilter: 'past',
        ));
      }
    } catch (e) {
      emit(GraphQLLaunchError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onFetchUpcomingLaunches(
    FetchUpcomingLaunches event,
    Emitter<GraphQLLaunchState> emit,
  ) async {
    try {
      if (state is GraphQLLaunchInitial) {
        emit(const GraphQLLaunchLoading());
      }

      final client = GraphQLConfig.clientInstance;
      final QueryOptions options = QueryOptions(
        document: gql(GET_UPCOMING_LAUNCHES_QUERY),
        variables: {
          'limit': event.limit,
          'offset': event.offset,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLLaunchError(
          message: GraphQLErrorHandler.handleError(result.exception!),
          isNetworkError: GraphQLErrorHandler.isNetworkError(result.exception!),
        ));
        return;
      }

      final List<dynamic> launchData = result.data?['launchesUpcoming'] ?? [];
      final List<GraphQLLaunch> launches =
          launchData.map((json) => GraphQLLaunch.fromJson(json)).toList();

      if (state is GraphQLLaunchesLoaded) {
        final currentState = state as GraphQLLaunchesLoaded;
        final allLaunches = [...currentState.launches, ...launches];
        emit(GraphQLLaunchesLoaded(
          launches: allLaunches,
          hasReachedMax: launches.length < event.limit,
          currentFilter: 'upcoming',
        ));
      } else {
        emit(GraphQLLaunchesLoaded(
          launches: launches,
          hasReachedMax: launches.length < event.limit,
          currentFilter: 'upcoming',
        ));
      }
    } catch (e) {
      emit(GraphQLLaunchError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onFilterLaunches(
    FilterLaunches event,
    Emitter<GraphQLLaunchState> emit,
  ) async {
    try {
      emit(const GraphQLLaunchLoading());

      final client = GraphQLConfig.clientInstance;
      List<GraphQLLaunch> allLaunches = [];

      // Determine which query to use based on filters
      if (event.showPast == true && event.showUpcoming != true) {
        // Fetch only past launches
        final QueryOptions options = QueryOptions(
          document: gql(GET_PAST_LAUNCHES_QUERY),
          variables: {
            'limit': 50,
            'offset': 0,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        );

        final QueryResult result = await client.query(options);

        if (result.hasException) {
          emit(GraphQLLaunchError(
            message: GraphQLErrorHandler.handleError(result.exception!),
            isNetworkError:
                GraphQLErrorHandler.isNetworkError(result.exception!),
          ));
          return;
        }

        final List<dynamic> launchData = result.data?['launchesPast'] ?? [];
        allLaunches =
            launchData.map((json) => GraphQLLaunch.fromJson(json)).toList();
      } else if (event.showUpcoming == true && event.showPast != true) {
        // Fetch only upcoming launches
        final QueryOptions options = QueryOptions(
          document: gql(GET_UPCOMING_LAUNCHES_QUERY),
          variables: {
            'limit': 50,
            'offset': 0,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        );

        final QueryResult result = await client.query(options);

        if (result.hasException) {
          emit(GraphQLLaunchError(
            message: GraphQLErrorHandler.handleError(result.exception!),
            isNetworkError:
                GraphQLErrorHandler.isNetworkError(result.exception!),
          ));
          return;
        }

        final List<dynamic> launchData = result.data?['launchesUpcoming'] ?? [];
        allLaunches =
            launchData.map((json) => GraphQLLaunch.fromJson(json)).toList();
      } else {
        final QueryOptions options = QueryOptions(
          document: gql(GET_LAUNCHES_QUERY),
          variables: {
            'limit': 50,
            'offset': 0,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        );

        final QueryResult result = await client.query(options);

        if (result.hasException) {
          emit(GraphQLLaunchError(
            message: GraphQLErrorHandler.handleError(result.exception!),
            isNetworkError:
                GraphQLErrorHandler.isNetworkError(result.exception!),
          ));
          return;
        }

        final List<dynamic> launchData = result.data?['launches'] ?? [];
        allLaunches =
            launchData.map((json) => GraphQLLaunch.fromJson(json)).toList();

        if (event.showPast == true && event.showUpcoming == true) {
        } else if (event.showPast == true && event.showUpcoming != true) {
          allLaunches =
              allLaunches.where((launch) => launch.upcoming != true).toList();
        } else if (event.showUpcoming == true && event.showPast != true) {
          allLaunches =
              allLaunches.where((launch) => launch.upcoming == true).toList();
        }
      }

      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        final searchQuery = event.searchQuery!.toLowerCase();
        allLaunches = allLaunches.where((launch) {
          return launch.missionName.toLowerCase().contains(searchQuery) ||
              launch.rocket.name.toLowerCase().contains(searchQuery) ||
              (launch.details?.toLowerCase().contains(searchQuery) ?? false);
        }).toList();
      }

      if (event.rocketName != null && event.rocketName!.isNotEmpty) {
        allLaunches = allLaunches
            .where((launch) => launch.rocket.name
                .toLowerCase()
                .contains(event.rocketName!.toLowerCase()))
            .toList();
      }

      emit(GraphQLLaunchesLoaded(
        launches: allLaunches,
        currentFilter: 'filtered',
        searchQuery: event.searchQuery,
        showPast: event.showPast,
        showUpcoming: event.showUpcoming,
      ));
    } catch (e) {
      emit(GraphQLLaunchError(message: 'An unexpected error occurred: $e'));
    }
  }

  void _onUpdateFilterState(
    UpdateFilterState event,
    Emitter<GraphQLLaunchState> emit,
  ) {
    if (state is GraphQLLaunchesLoaded) {
      final currentState = state as GraphQLLaunchesLoaded;
      emit(currentState.copyWith(
        searchQuery: event.searchQuery,
        showPast: event.showPast,
        showUpcoming: event.showUpcoming,
      ));
    }
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<GraphQLLaunchState> emit,
  ) {
    if (state is GraphQLLaunchesLoaded) {
      final currentState = state as GraphQLLaunchesLoaded;
      emit(currentState.copyWith(
        searchQuery: null,
        showPast: null,
        showUpcoming: null,
      ));
    }
  }
}
