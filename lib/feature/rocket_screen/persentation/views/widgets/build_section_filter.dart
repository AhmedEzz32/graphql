import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/graph_rocket_bloc.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_bloc_state.dart';
import 'package:spacex_information_app/feature/rocket_screen/data/rocket_event_bloc.dart';
import 'package:spacex_information_app/core/widgets/search_text_field.dart';

Widget buildFilterSection(BuildContext context, GraphQLRocketState state) {
  final String currentSearchQuery =
      state is GraphQLRocketsLoaded ? (state.searchQuery ?? '') : '';
  final bool isActiveSelected =
      state is GraphQLRocketsLoaded ? (state.showActive == true) : false;
  final bool isInactiveSelected =
      state is GraphQLRocketsLoaded ? (state.showInactive == true) : false;

  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        SearchTextField(
          initialValue: currentSearchQuery,
          onChanged: (value) {
            context
                .read<GraphQLRocketBloc>()
                .add(UpdateRocketFilterState(searchQuery: value));
            _applyFilters(context, value, isActiveSelected ? true : null,
                isInactiveSelected ? true : null);
          },
          onClear: () {
            context
                .read<GraphQLRocketBloc>()
                .add(const UpdateRocketFilterState(searchQuery: ''));
            _applyFilters(context, '', null, null);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilterChip(
                label: const Text('Active Only'),
                selected: isActiveSelected,
                selectedColor: Colors.green.withValues(alpha: 0.2),
                checkmarkColor: Colors.green,
                onSelected: (selected) {
                  final newActiveFilter = selected ? true : null;
                  final newInactiveFilter =
                      selected ? null : (isInactiveSelected ? true : null);

                  context.read<GraphQLRocketBloc>().add(UpdateRocketFilterState(
                        searchQuery: currentSearchQuery,
                        showActive: newActiveFilter,
                        showInactive: newInactiveFilter,
                      ));
                  _applyFilters(context, currentSearchQuery, newActiveFilter,
                      newInactiveFilter);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilterChip(
                label: const Text('Inactive Only'),
                selected: isInactiveSelected,
                selectedColor: Colors.red.withValues(alpha: 0.2),
                checkmarkColor: Colors.red,
                onSelected: (selected) {
                  final newInactiveFilter = selected ? true : null;
                  final newActiveFilter =
                      selected ? null : (isActiveSelected ? true : null);

                  context.read<GraphQLRocketBloc>().add(UpdateRocketFilterState(
                        searchQuery: currentSearchQuery,
                        showActive: newActiveFilter,
                        showInactive: newInactiveFilter,
                      ));
                  _applyFilters(context, currentSearchQuery, newActiveFilter,
                      newInactiveFilter);
                },
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                context
                    .read<GraphQLRocketBloc>()
                    .add(const ClearRocketFilters());
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

void _applyFilters(BuildContext context, String? searchQuery, bool? showActive,
    bool? showInactive) {
  context.read<GraphQLRocketBloc>().add(
        FilterRockets(
          searchQuery: searchQuery?.isNotEmpty == true ? searchQuery : null,
          showActive: showActive,
          showInactive: showInactive,
        ),
      );
}
