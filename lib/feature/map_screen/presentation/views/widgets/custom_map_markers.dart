import 'package:flutter/material.dart';
import '../../view_models/space_location.dart';

class CustomMapMarkers {
  static Widget buildLaunchSiteMarker({
    required SpaceLocation location,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSelected ? 60 : 40,
        height: isSelected ? 60 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFFFF6B35),
              Color(0xFFFF8E53),
              Color(0xFFFFA07A),
            ],
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withValues(alpha: 0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          Icons.rocket_launch,
          color: Colors.white,
          size: isSelected ? 30 : 20,
        ),
      ),
    );
  }

  static Widget buildLandingZoneMarker({
    required SpaceLocation location,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSelected ? 50 : 35,
        height: isSelected ? 50 : 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF66BB6A),
              Color(0xFF81C784),
            ],
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.6),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.flight_land,
          color: Colors.white,
          size: isSelected ? 25 : 18,
        ),
      ),
    );
  }

  static Widget buildDroneShipMarker({
    required SpaceLocation location,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSelected ? 50 : 35,
        height: isSelected ? 50 : 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFF2196F3),
              Color(0xFF42A5F5),
              Color(0xFF64B5F6),
            ],
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withValues(alpha: 0.6),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.directions_boat,
          color: Colors.white,
          size: isSelected ? 25 : 18,
        ),
      ),
    );
  }

  static Widget buildObservationPointMarker({
    required ObservationLocation location,
    required bool isRecommended,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isRecommended ? 40 : 30,
        height: isRecommended ? 40 : 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: isRecommended
                ? [
                    const Color(0xFFFFD700),
                    const Color(0xFFFFF176),
                    const Color(0xFFFFF59D),
                  ]
                : [
                    const Color(0xFF9C27B0),
                    const Color(0xFFBA68C8),
                    const Color(0xFFCE93D8),
                  ],
          ),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isRecommended
                      ? const Color(0xFFFFD700)
                      : const Color(0xFF9C27B0))
                  .withValues(alpha: 0.6),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.visibility,
          color: Colors.white,
          size: isRecommended ? 20 : 15,
        ),
      ),
    );
  }

  static Widget buildUserLocationMarker() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  static Widget buildTrajectoryMarker({
    required TrajectoryPoint point,
    required bool isActive,
  }) {
    Color color;
    IconData icon;

    switch (point.phase) {
      case 'launch':
        color = const Color(0xFFFF6B35);
        icon = Icons.rocket_launch;
        break;
      case 'ascent':
        color = const Color(0xFFFF9800);
        icon = Icons.trending_up;
        break;
      case 'orbit':
        color = const Color(0xFF2196F3);
        icon = Icons.public;
        break;
      case 'descent':
        color = const Color(0xFF9C27B0);
        icon = Icons.trending_down;
        break;
      case 'landing':
        color = const Color(0xFF4CAF50);
        icon = Icons.flight_land;
        break;
      default:
        color = Colors.grey;
        icon = Icons.circle;
    }

    return Container(
      width: isActive ? 20 : 10,
      height: isActive ? 20 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: isActive
          ? Icon(
              icon,
              color: Colors.white,
              size: 12,
            )
          : null,
    );
  }
}
