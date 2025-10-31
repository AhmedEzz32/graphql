import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/data/graph_launch_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/data/launch_state_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/data/launch_event_bloc.dart';
import 'package:spacex_information_app/core/widgets/search_text_field.dart';

Widget buildLaunchFilterSection(
    BuildContext context, GraphQLLaunchState state) {
  final String currentSearchQuery =
      state is GraphQLLaunchesLoaded ? (state.searchQuery ?? '') : '';
  final bool isPastSelected =
      state is GraphQLLaunchesLoaded ? (state.showPast == true) : false;
  final bool isUpcomingSelected =
      state is GraphQLLaunchesLoaded ? (state.showUpcoming == true) : false;

  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        SearchTextField(
          initialValue: currentSearchQuery,
          onChanged: (value) {
            context
                .read<GraphQLLaunchBloc>()
                .add(UpdateFilterState(searchQuery: value));
          },
          onClear: () {
            context
                .read<GraphQLLaunchBloc>()
                .add(const UpdateFilterState(searchQuery: ''));
            _applyFilters(context, '', null, null);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilterChip(
                label: const Text('Past'),
                selected: isPastSelected,
                selectedColor: Colors.blue.withValues(alpha: 0.2),
                checkmarkColor: Colors.blue,
                onSelected: (selected) {
                  final newPastFilter = selected ? true : null;
                  final newUpcomingFilter =
                      selected ? null : (isUpcomingSelected ? true : null);

                  context.read<GraphQLLaunchBloc>().add(UpdateFilterState(
                        searchQuery: currentSearchQuery,
                        showPast: newPastFilter,
                        showUpcoming: newUpcomingFilter,
                      ));
                  _applyFilters(context, currentSearchQuery, newPastFilter,
                      newUpcomingFilter);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilterChip(
                label: const Text('Upcoming'),
                selected: isUpcomingSelected,
                selectedColor: Colors.orange.withValues(alpha: 0.2),
                checkmarkColor: Colors.orange,
                onSelected: (selected) {
                  final newUpcomingFilter = selected ? true : null;
                  final newPastFilter =
                      selected ? null : (isPastSelected ? true : null);

                  context.read<GraphQLLaunchBloc>().add(UpdateFilterState(
                        searchQuery: currentSearchQuery,
                        showPast: newPastFilter,
                        showUpcoming: newUpcomingFilter,
                      ));
                  _applyFilters(context, currentSearchQuery, newPastFilter,
                      newUpcomingFilter);
                },
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                context.read<GraphQLLaunchBloc>().add(const ClearFilters());
                _applyFilters(context, null, null, null);
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ],
    ),
  );
}

void _applyFilters(BuildContext context, String? searchQuery, bool? showPast,
    bool? showUpcoming) {
  context.read<GraphQLLaunchBloc>().add(
        FilterLaunches(
          searchQuery: searchQuery?.isNotEmpty == true ? searchQuery : null,
          showPast: showPast,
          showUpcoming: showUpcoming,
        ),
      );
}
