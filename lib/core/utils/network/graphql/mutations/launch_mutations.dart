// Note: SpaceX GraphQL API is read-only and doesn't support mutations for user comments.
// This is a demonstration of how mutations would be implemented if they were available.

// ignore_for_file: constant_identifier_names

const String ADD_LAUNCH_COMMENT_MUTATION = '''
  mutation AddLaunchComment(\$launchId: ID!, \$comment: String!, \$userId: ID!) {
    addLaunchComment(
      launch_id: \$launchId
      comment: \$comment
      user_id: \$userId
    ) {
      id
      comment
      user_id
      launch_id
      created_at
      user {
        id
        name
        email
      }
    }
  }
''';

const String UPDATE_LAUNCH_COMMENT_MUTATION = '''
  mutation UpdateLaunchComment(\$commentId: ID!, \$comment: String!) {
    updateLaunchComment(
      id: \$commentId
      comment: \$comment
    ) {
      id
      comment
      updated_at
    }
  }
''';

const String DELETE_LAUNCH_COMMENT_MUTATION = '''
  mutation DeleteLaunchComment(\$commentId: ID!) {
    deleteLaunchComment(id: \$commentId) {
      success
      message
    }
  }
''';

// Demonstration query for getting launch comments (if they existed)
const String GET_LAUNCH_COMMENTS_QUERY = '''
  query GetLaunchComments(\$launchId: ID!, \$limit: Int, \$offset: Int) {
    launchComments(launch_id: \$launchId, limit: \$limit, offset: \$offset) {
      id
      comment
      launch_id
      user_id
      created_at
      updated_at
      user {
        id
        name
        email
        avatar_url
      }
    }
  }
''';

// Company information mutation (demonstration)
const String UPDATE_COMPANY_INFO_MUTATION = '''
  mutation UpdateCompanyInfo(\$input: CompanyUpdateInput!) {
    updateCompany(input: \$input) {
      id
      name
      founder
      founded
      employees
      vehicles
      launch_sites
      test_sites
      ceo
      cto
      coo
      cto_propulsion
      valuation
      headquarters {
        address
        city
        state
      }
      summary
    }
  }
''';
