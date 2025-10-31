import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view/launch_screen.dart';
import '../../../rocket_screen/persentation/views/rocket_screen.dart';
import '../../../company_screen/persentation/views/company_screen_view.dart';
import '../../../map_screen/presentation/views/space_map_screen.dart';
import '../../data/home_bloc.dart';
import '../../data/home_event.dart';
import '../../data/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Widget> _screens = [
    RocketScreen(),
    LaunchScreen(),
    CompanyScreen(),
    SpaceMapScreen(),
  ];

  static const List<String> _titles = [
    'Rockets',
    'Launches',
    'Company',
    'Map',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titles[state.selectedIndex]),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              centerTitle: true,
            ),
            body: IndexedStack(
              index: state.selectedIndex,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: state.selectedIndex,
              onTap: (index) {
                if (state.selectedIndex != index) {
                  context.read<HomeBloc>().add(ChangeTab(index));
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.rocket_launch),
                  label: 'Rockets',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.flight_takeoff),
                  label: 'Launches',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Company',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Map',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
