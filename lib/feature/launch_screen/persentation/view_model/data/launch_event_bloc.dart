import 'package:equatable/equatable.dart';

abstract class GraphQLLaunchEvent extends Equatable {
  const GraphQLLaunchEvent();

  @override
  List<Object?> get props => [];
}

class FetchLaunches extends GraphQLLaunchEvent {
  final int limit;
  final int offset;
  final String? sort;
  final String? order;

  const FetchLaunches({
    this.limit = 10,
    this.offset = 0,
    this.sort,
    this.order,
  });

  @override
  List<Object?> get props => [limit, offset, sort, order];
}

class FetchPastLaunches extends GraphQLLaunchEvent {
  final int limit;
  final int offset;

  const FetchPastLaunches({
    this.limit = 10,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [limit, offset];
}

class FetchUpcomingLaunches extends GraphQLLaunchEvent {
  final int limit;
  final int offset;

  const FetchUpcomingLaunches({
    this.limit = 10,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [limit, offset];
}

class FetchLaunchDetails extends GraphQLLaunchEvent {
  final String launchId;

  const FetchLaunchDetails(this.launchId);

  @override
  List<Object?> get props => [launchId];
}

class FilterLaunches extends GraphQLLaunchEvent {
  final String? rocketName;
  final String? launchYear;
  final bool? launchSuccess;

  const FilterLaunches({
    this.rocketName,
    this.launchYear,
    this.launchSuccess,
  });

  @override
  List<Object?> get props => [rocketName, launchYear, launchSuccess];
}

class RefreshLaunches extends GraphQLLaunchEvent {
  const RefreshLaunches();
}
