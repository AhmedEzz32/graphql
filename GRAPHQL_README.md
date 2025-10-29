# SpaceX Information App - GraphQL Implementation

This Flutter application demonstrates both REST API and GraphQL implementations for accessing SpaceX data, showcasing advanced state management with BLoC pattern, offline caching, error handling, and typed model generation.

## Features

### REST API Implementation (Original)
- ✅ Complete BLoC pattern implementation
- ✅ Rocket listing and details
- ✅ Launch information with filtering
- ✅ Mission details
- ✅ Company information
- ✅ Error handling and loading states

### GraphQL Implementation (New)
- ✅ GraphQL client configuration with Hive caching
- ✅ Typed Dart models from GraphQL schema
- ✅ Comprehensive query and mutation operations
- ✅ Offline caching with cache policies
- ✅ Error handling and retry logic
- ✅ Pagination support
- ✅ Real-time data fetching with optimistic updates

## GraphQL Features

### 1. Client Configuration
```dart
// lib/graphql/config/graphql_config.dart
- Hive-based offline storage
- Error handling middleware
- Automatic cache management
- Network error detection and retry logic
```

### 2. Queries Implemented
```graphql
# Rocket Queries
- GET_ROCKETS_QUERY: Paginated rocket listing
- GET_ROCKET_DETAILS_QUERY: Detailed rocket information
- SEARCH_ROCKETS_QUERY: Search rockets by name/type

# Launch Queries  
- GET_LAUNCHES_QUERY: All launches with filtering
- GET_PAST_LAUNCHES_QUERY: Historical launches
- GET_UPCOMING_LAUNCHES_QUERY: Future launches
- GET_LAUNCH_DETAILS_QUERY: Detailed launch information
```

### 3. Mutations (Demonstration)
```graphql
# Comment Mutations (Demo - SpaceX API is read-only)
- ADD_LAUNCH_COMMENT_MUTATION: Add user comments
- UPDATE_LAUNCH_COMMENT_MUTATION: Update comments
- DELETE_LAUNCH_COMMENT_MUTATION: Remove comments
```

### 4. Typed Models
- **GraphQLRocket**: Complete rocket specifications
- **GraphQLLaunch**: Comprehensive launch data
- **GraphQLPayload**: Payload information
- **GraphQLCore**: Booster core details
- **GraphQLShip**: Recovery ship data
- JSON serialization with build_runner code generation

### 5. BLoC State Management
```dart
# GraphQLRocketBloc
- FetchRockets: Paginated rocket loading
- FetchRocketDetails: Single rocket details
- SearchRockets: Rocket search functionality
- RefreshRockets: Pull-to-refresh

# GraphQLLaunchBloc  
- FetchLaunches: All launches
- FetchPastLaunches: Historical data
- FetchUpcomingLaunches: Future launches
- FilterLaunches: Advanced filtering
- RefreshLaunches: Data refresh
```

## Getting Started

### Prerequisites
- Flutter 3.6.2 or higher
- Dart 2.19.0 or higher

### Installation
1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Generate GraphQL models:
```bash
dart run build_runner build
```

4. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                          # App entry point with GraphQL initialization
├── graphql/                           # GraphQL implementation
│   ├── config/
│   │   └── graphql_config.dart        # Client configuration and caching
│   ├── queries/
│   │   ├── rocket_queries.dart        # Rocket GraphQL queries
│   │   ├── launch_queries.dart        # Launch GraphQL queries
│   │   └── launch_mutations.dart      # Mutation demonstrations
│   ├── models/
│   │   ├── graphql_rocket_models.dart # Typed rocket models
│   │   ├── graphql_launch_models.dart # Typed launch models
│   │   ├── *.g.dart                   # Generated JSON serialization
│   └── blocs/
│       ├── graphql_rocket_bloc.dart   # Rocket state management
│       └── graphql_launch_bloc.dart   # Launch state management
├── screens/
│   └── graphql_demo_screen.dart       # GraphQL demo UI
├── feature/                           # Original REST implementation
├── bloc/                              # REST API BLoCs
├── models/                            # REST API models
└── services/                          # REST API services
```

## Key Dependencies

### GraphQL & Caching
```yaml
graphql_flutter: ^5.1.2              # GraphQL client
hive_flutter: ^1.1.0                 # Local caching
path_provider: ^2.1.1                # Storage paths
```

### State Management & Serialization
```yaml
flutter_bloc: ^8.1.3                 # BLoC pattern
equatable: ^2.0.5                    # Value equality
json_annotation: ^4.8.1              # JSON serialization
```

### Development Tools
```yaml
build_runner: ^2.4.7                 # Code generation
json_serializable: ^6.7.1            # JSON code generation
```

## GraphQL Endpoint
- **SpaceX GraphQL API**: https://spacex-production.up.railway.app/
- **Schema Explorer**: Available through GraphQL Playground

## Offline Caching Strategy

### Cache Policies
- **cacheAndNetwork**: Load from cache first, then network
- **cacheFirst**: Prefer cached data, fallback to network
- **networkOnly**: Always fetch fresh data
- **cacheOnly**: Only use cached data

### Cache Management
```dart
// Clear all cached data
await GraphQLCacheManager.clearCache();

// Remove specific cache entry
await GraphQLCacheManager.removeFromCache(key);

// Get cached data
final data = await GraphQLCacheManager.getFromCache(key);
```

## Error Handling

### Network Errors
- Automatic retry with exponential backoff
- Network connectivity detection
- User-friendly error messages
- Fallback to cached data

### GraphQL Errors
- Server error handling
- Query validation errors
- Rate limiting handling
- Partial data support

## Usage Examples

### Accessing GraphQL Demo
1. Launch the application
2. Click the API icon in the app bar
3. Explore the three tabs:
   - **Rockets**: Paginated rocket listing with search
   - **Past Launches**: Historical launch data
   - **Upcoming**: Future launch schedule

### Features Demonstrated
- **Pagination**: Infinite scroll loading
- **Search**: Real-time rocket search
- **Filtering**: Launch success/failure filtering
- **Caching**: Offline data availability
- **Error Handling**: Network error simulation
- **Pull-to-Refresh**: Data synchronization

## Performance Optimizations

### GraphQL Benefits
- **Reduced Data Transfer**: Query only needed fields
- **Single Endpoint**: Eliminate multiple REST calls
- **Type Safety**: Compile-time error checking
- **Caching**: Intelligent cache normalization
- **Real-time**: Subscription support (when available)

### Caching Strategy
- **Memory Cache**: In-app data persistence
- **Disk Cache**: Hive-based offline storage
- **Cache Invalidation**: TTL and manual refresh
- **Optimistic Updates**: Immediate UI updates

## Testing

### Unit Tests
Run unit tests for BLoCs and services:
```bash
flutter test
```

### Integration Tests
Test GraphQL queries and caching:
```bash
flutter test integration_test/
```

## Troubleshooting

### Common Issues

1. **Build Runner Errors**
```bash
flutter packages pub run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

2. **GraphQL Connection Issues**
```bash
# Check network connectivity
# Verify API endpoint accessibility
curl https://spacex-production.up.railway.app/
```

3. **Cache Issues**
```bash
# Clear application data
flutter clean
flutter pub get
dart run build_runner build
```

## Future Enhancements

### GraphQL Subscriptions
- Real-time launch updates
- Live mission status
- Rocket telemetry streams

### Advanced Features
- GraphQL code generation from schema
- Automatic cache optimization
- Background data synchronization
- Multi-environment configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes with tests
4. Update documentation
5. Submit pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources

- [SpaceX API Documentation](https://github.com/r-spacex/SpaceX-API)
- [GraphQL Flutter Package](https://pub.dev/packages/graphql_flutter)
- [Flutter BLoC Pattern](https://pub.dev/packages/flutter_bloc)
- [Hive Local Database](https://pub.dev/packages/hive)