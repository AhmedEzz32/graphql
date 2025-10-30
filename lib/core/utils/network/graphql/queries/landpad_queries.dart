
const String GET_LANDPADS_QUERY = r'''
  query GetLandpads($limit: Int!, $offset: Int!) {
    landpads(limit: $limit, offset: $offset) {
      id
      full_name
      location {
        latitude
        longitude
        name
        region
      }
    }
  }
''';