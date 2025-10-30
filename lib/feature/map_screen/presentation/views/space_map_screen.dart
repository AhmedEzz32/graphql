import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'widgets/space_map_widget.dart';

class SpaceMapScreen extends StatefulWidget {
  const SpaceMapScreen({super.key});

  @override
  State<SpaceMapScreen> createState() => _SpaceMapScreenState();
}

class _SpaceMapScreenState extends State<SpaceMapScreen> {
  final GlobalKey<State<SpaceMapWidget>> _mapWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Route Map'),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchOptions,
            tooltip: 'Search viewing locations',
          ),
          IconButton(
            icon: const Icon(Icons.route),
            tooltip: 'Show Route',
            onPressed: _createSimpleRoute,
          ),
        ],
      ),
      body: SpaceMapWidget(
        key: _mapWidgetKey,
      ),
    );
  }

  void _createSimpleRoute() {
    final state = _mapWidgetKey.currentState;
    if (state != null) {
      const origin = LatLng(37.7749, -122.4194);
      const destination = LatLng(37.3382, -121.8863);
      (state as dynamic).createRoute(origin, destination);
    }
  }

  void _showSearchOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a2e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search Locations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search for a location...',
                hintStyle: TextStyle(color: Colors.white60),
                prefixIcon: Icon(Icons.search, color: Colors.white60),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onSubmitted: (value) {
                // Handle search here
                Navigator.pop(context);
                _searchLocation(value);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Popular Locations:',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildLocationTile('San Francisco', 37.7749, -122.4194),
                  _buildLocationTile('San Jose', 37.3382, -121.8863),
                  _buildLocationTile('Los Angeles', 34.0522, -118.2437),
                  _buildLocationTile('New York', 40.7128, -74.0060),
                  _buildLocationTile('Miami', 25.7617, -80.1918),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTile(String name, double lat, double lng) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
        style: const TextStyle(color: Colors.white60),
      ),
      leading: const Icon(Icons.location_on, color: Colors.blue),
      onTap: () {
        Navigator.pop(context);
        _goToLocation(lat, lng, name);
      },
    );
  }

  void _searchLocation(String query) {
    // Simple search implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for: $query'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _goToLocation(double lat, double lng, String name) {
    final state = _mapWidgetKey.currentState;
    if (state != null) {
      const origin = LatLng(37.7749, -122.4194);
      final destination = LatLng(lat, lng);

      (state as dynamic).createRoute(origin, destination);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Creating route to: $name'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
