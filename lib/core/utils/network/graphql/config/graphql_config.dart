import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GraphQLConfig {
  static const String _baseUrl = 'https://spacex-production.up.railway.app/';
  static ValueNotifier<GraphQLClient>? client;
  static late HiveStore store;

  static Future<void> initialize() async {
    await initHiveForFlutter();

    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Initialize Hive store for caching
    store = await HiveStore.open();

    final cache = GraphQLCache(store: store);

    client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: cache,
      ),
    );
  }

  static GraphQLClient get clientInstance {
    if (client == null) {
      throw Exception(
          'GraphQL client not initialized. Call GraphQLConfig.initialize() first.');
    }
    return client!.value;
  }

  static Future<void> dispose() async {
    await Hive.close();
  }
}
