import 'package:equatable/equatable.dart';

abstract class GraphQLRocketEvent extends Equatable {
  const GraphQLRocketEvent();

  @override
  List<Object?> get props => [];
}

class FetchRockets extends GraphQLRocketEvent {
  final int limit;
  final int offset;

  const FetchRockets({
    this.limit = 10,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [limit, offset];
}

class FetchRocketDetails extends GraphQLRocketEvent {
  final String rocketId;

  const FetchRocketDetails(this.rocketId);

  @override
  List<Object?> get props => [rocketId];
}

class SearchRockets extends GraphQLRocketEvent {
  final String searchTerm;

  const SearchRockets(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class FilterRockets extends GraphQLRocketEvent {
  final String? searchQuery;
  final bool? showActive;
  final bool? showInactive;

  const FilterRockets({
    this.searchQuery,
    this.showActive,
    this.showInactive,
  });

  @override
  List<Object?> get props => [searchQuery, showActive, showInactive];
}

class RefreshRockets extends GraphQLRocketEvent {
  const RefreshRockets();
}
