import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/map_screen/models/place_result.dart';
import '../../view_models/map_bloc.dart';
import '../../view_models/map_event.dart';
import '../../view_models/map_state.dart';

class MapSearchWidget extends StatefulWidget {
  const MapSearchWidget({super.key});

  @override
  State<MapSearchWidget> createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends State<MapSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<PlaceResult> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapLoaded) {
          setState(() {
            _searchResults = state.placesSearchResults;
            _isSearching = false;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchField(),
            if (_searchResults.isNotEmpty || _isSearching)
              _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search launch viewing locations...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFFF6B35)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults.clear();
                      _isSearching = false;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: _onSearchChanged,
        onSubmitted: _onSearchSubmitted,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return Container(
        height: 60,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _searchResults.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final place = _searchResults[index];
          return _buildPlaceResultTile(place);
        },
      ),
    );
  }

  Widget _buildPlaceResultTile(PlaceResult place) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: place.isRecommendedForLaunchViewing
              ? const Color(0xFFFF6B35)
              : Colors.grey[400],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getIconForPlace(place),
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        place.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.vicinity,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 14,
                color: Colors.amber[600],
              ),
              const SizedBox(width: 2),
              Text(
                place.rating.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: place.isRecommendedForLaunchViewing
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Recommended',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      onTap: () => _onPlaceSelected(place),
    );
  }

  IconData _getIconForPlace(PlaceResult place) {
    final types = place.types;
    if (types.contains('park')) return Icons.park;
    if (types.contains('tourist_attraction')) return Icons.camera_alt;
    if (types.contains('natural_feature')) return Icons.waves;
    if (place.name.toLowerCase().contains('beach')) return Icons.beach_access;
    if (place.name.toLowerCase().contains('pier')) return Icons.rowing;
    if (place.name.toLowerCase().contains('lighthouse')) return Icons.lightbulb;
    return Icons.place;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
      return;
    }

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query && query.isNotEmpty) {
        _performSearch(query);
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _performSearch(query);
    }
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    context.read<MapBloc>().add(SearchPlaces(query: query));
  }

  void _onPlaceSelected(PlaceResult place) {
    // Hide search results
    setState(() {
      _searchResults.clear();
      _isSearching = false;
    });

    // Clear search field
    _searchController.clear();

    // Send event to MapBloc to update map with selected place and create polyline
    context.read<MapBloc>().add(SelectPlace(
          latitude: place.latitude,
          longitude: place.longitude,
          placeName: place.name,
        ));

    // Show confirmation with polyline creation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to: ${place.name}\nPolyline route created'),
        backgroundColor: const Color(0xFFFF6B35),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
