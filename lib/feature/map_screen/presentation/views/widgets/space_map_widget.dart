import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpaceMapWidget extends StatefulWidget {
  const SpaceMapWidget({super.key});

  @override
  State<SpaceMapWidget> createState() => _SpaceMapWidgetState();
}

class _SpaceMapWidgetState extends State<SpaceMapWidget>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? origin;
  LatLng? destination;

  final List<LatLng> _curvePoints = [];
  Timer? _animationTimer;
  bool _isAnimating = false;

  // Animation controller for smooth movement
  late AnimationController _rocketAnimationController;

  BitmapDescriptor? rocketIcon;
  BitmapDescriptor? destinationReachedIcon;
  bool _iconLoaded = false;

  @override
  void initState() {
    super.initState();
    _rocketAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _loadRocketIcon();
    _loadDestinationIcon();
  }

  Future<void> _loadRocketIcon() async {
    try {
      rocketIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(32, 32)),
        'assets/icons/rocket.png',
      );
      setState(() {
        _iconLoaded = true;
      });
    } catch (e) {
      // Fallback to default marker if rocket icon fails to load
      rocketIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      setState(() {
        _iconLoaded = true;
      });
      print('Failed to load rocket icon: $e');
    }
  }

  Future<void> _loadDestinationIcon() async {
    try {
      destinationReachedIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 40)),
        'assets/icons/rocket.png',
      );
    } catch (e) {
      // Fallback to default marker
      destinationReachedIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      print('Failed to load destination reached icon: $e');
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _rocketAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🚀 Rocket Route Animation"),
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
            onPressed: _clearAll,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 10,
            ),
            mapType: MapType.normal,
            markers: _markers,
            polylines: _polylines,
            zoomControlsEnabled: true,
            onTap: _handleMapTap,
          ),
          if (!_iconLoaded)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_curvePoints.isNotEmpty && !_isAnimating && _iconLoaded)
            FloatingActionButton.extended(
              onPressed: _animateRocket,
              heroTag: "animate_rocket",
              label: const Text("Launch Rocket"),
              icon: const Icon(Icons.rocket_launch),
              backgroundColor: Colors.orange,
            ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _iconLoaded
                ? () {
                    if (origin != null && destination != null) {
                      _createCurvedRoute(origin!, destination!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Tap twice on map: first for start point, then for destination"),
                        ),
                      );
                    }
                  }
                : null,
            heroTag: "create_route",
            label: const Text("Create Route"),
            icon: const Icon(Icons.route),
          ),
        ],
      ),
    );
  }

  void _handleMapTap(LatLng tappedPoint) {
    // Place origin and destination markers
    if (origin == null) {
      setState(() {
        origin = tappedPoint;
        _markers.add(
          Marker(
            markerId: const MarkerId('origin'),
            position: tappedPoint,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            infoWindow: const InfoWindow(title: 'Launch Pad'),
          ),
        );
      });
    } else if (destination == null) {
      setState(() {
        destination = tappedPoint;
        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: tappedPoint,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: 'Target'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Clear map to choose new points")),
      );
    }
  }

  void _clearAll() {
    setState(() {
      origin = null;
      destination = null;
      _markers.clear();
      _polylines.clear();
      _curvePoints.clear();
      _isAnimating = false;
      _animationTimer?.cancel();
    });
  }

  void _createCurvedRoute(LatLng origin, LatLng destination) {
    _polylines.clear();
    _curvePoints.clear();
    _animationTimer?.cancel();

    // Stronger curve
    const double offset = 0.6;

    // Midpoint offset perpendicular
    final double midLat = (origin.latitude + destination.latitude) / 2;
    final double midLng = (origin.longitude + destination.longitude) / 2;
    final double dx = destination.longitude - origin.longitude;
    final double dy = destination.latitude - origin.latitude;
    final double d = sqrt(dx * dx + dy * dy);
    final double nx = -dy / d;
    final double ny = dx / d;

    final LatLng controlPoint = LatLng(
      midLat + offset * ny,
      midLng + offset * nx,
    );

    // More points for much smoother animation (500 points instead of 101)
    for (double t = 0; t <= 1; t += 0.02) {
      final double lat = (1 - t) * (1 - t) * origin.latitude +
          2 * (1 - t) * t * controlPoint.latitude +
          t * t * destination.latitude;
      final double lng = (1 - t) * (1 - t) * origin.longitude +
          2 * (1 - t) * t * controlPoint.longitude +
          t * t * destination.longitude;
      _curvePoints.add(LatLng(lat, lng));
    }

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("curved_route"),
          color: Colors.lightBlueAccent,
          width: 6,
          points: _curvePoints,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    });

    // Show message to user about using the Launch button
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            "🚀 Route created! Use 'Launch Rocket' button to start animation"),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _animateRocket() {
    if (_curvePoints.isEmpty || !_iconLoaded || _isAnimating) return;

    setState(() => _isAnimating = true);

    int index = 0;

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (index >= _curvePoints.length) {
        timer.cancel();
        setState(() => _isAnimating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🚀 Rocket reached destination!"),
          ),
        );
        return;
      }

      final current = _curvePoints[index];
      LatLng? next;
      if (index + 1 < _curvePoints.length) next = _curvePoints[index + 1];

      double bearing = 0;
      if (next != null) bearing = _calculateBearing(current, next);

      setState(() {
        _markers.removeWhere((m) => m.markerId == const MarkerId('rocket'));
        _markers.add(
          Marker(
            markerId: const MarkerId('rocket'),
            position: current,
            rotation: bearing,
            anchor: const Offset(0.5, 0.5),
            icon: rocketIcon!,
          ),
        );
      });

      // Move camera with rocket
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: current,
            zoom: 14.0,
            bearing: bearing,
          ),
        ),
      );

      index++;
    });
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final double lat1 = _degreesToRadians(start.latitude);
    final double lon1 = _degreesToRadians(start.longitude);
    final double lat2 = _degreesToRadians(end.latitude);
    final double lon2 = _degreesToRadians(end.longitude);

    final double dLon = lon2 - lon1;
    final double y = sin(dLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final double brng = atan2(y, x);
    return (_radiansToDegrees(brng) + 360) % 360;
  }

  double _degreesToRadians(double deg) => deg * pi / 180;
  double _radiansToDegrees(double rad) => rad * 180 / pi;
}
