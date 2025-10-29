import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLErrorHandler {
  static String handleError(OperationException error) {
    if (error.linkException != null) {
      if (error.linkException is NetworkException) {
        return 'Network error: Please check your internet connection';
      } else if (error.linkException is ServerException) {
        return 'Server error: ${error.linkException.toString()}';
      } else {
        return 'Connection error: ${error.linkException.toString()}';
      }
    } else if (error.graphqlErrors.isNotEmpty) {
      return 'GraphQL error: ${error.graphqlErrors.first.message}';
    } else {
      return 'Unknown error occurred';
    }
  }

  static bool isNetworkError(OperationException error) {
    return error.linkException is NetworkException;
  }

  static bool shouldRetry(OperationException error) {
    return error.linkException is NetworkException;
  }
}
