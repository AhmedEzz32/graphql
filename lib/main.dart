import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_information_app/core/services/location_permission_service.dart';
import 'package:spacex_information_app/core/utils/network/graphql/config/graphql_config.dart';
import 'package:spacex_information_app/feature/launch_screen/persentation/view_model/data/launch_bloc_state.dart';
import 'package:spacex_information_app/feature/rocket_screen/persentation/views_model/data/rocket_bloc_state.dart';
import 'package:spacex_information_app/feature/map_screen/presentation/view_models/map_bloc.dart';
import 'feature/home_screen/persentation/views/home_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await GraphQLConfig.initialize();
    await LocationPermissionService().initialize();
  } catch (e) {
    debugPrint('Failed to initialize GraphQL: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GraphQLRocketBloc>(
          create: (context) => GraphQLRocketBloc(),
        ),
        BlocProvider<GraphQLLaunchBloc>(
          create: (context) => GraphQLLaunchBloc(),
        ),
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SpaceX Information App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
