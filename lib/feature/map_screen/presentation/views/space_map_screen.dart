import 'package:flutter/material.dart';
import 'widgets/space_map_widget.dart';

class SpaceMapScreen extends StatelessWidget {
  const SpaceMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpaceMapWidget(),
    );
  }
}
