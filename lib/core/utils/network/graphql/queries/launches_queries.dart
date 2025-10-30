// SpaceX GraphQL Queries - Updated and working

// Launches
const String GET_LAUNCHES_QUERY = '''
  query GetLaunches(\$limit: Int, \$offset: Int) {
    launches(limit: \$limit, offset: \$offset) {
      id
      mission_name
      launch_date_utc
      rocket {
        rocket_name
        rocket_type
      }
      launch_site {
        site_name_long
      }
      details
      links {
        article_link
        video_link
      }
      upcoming
      launch_success
    }
  }
''';

const String GET_LAUNCH_DETAILS_QUERY = '''
  query GetLaunchDetails(\$id: ID!) {
    launch(id: \$id) {
      id
      mission_name
      launch_date_utc
      rocket {
        rocket_name
        rocket_type
      }
      launch_site {
        site_name_long
      }
      details
      links {
        article_link
        video_link
      }
      upcoming
      launch_success
    }
  }
''';

const String GET_PAST_LAUNCHES_QUERY = '''
  query GetPastLaunches(\$limit: Int, \$offset: Int) {
    launchesPast(limit: \$limit, offset: \$offset) {
      id
      mission_name
      launch_date_utc
      rocket {
        rocket_name
        rocket_type
      }
      launch_site {
        site_name_long
      }
      details
      links {
        article_link
        video_link
      }
      launch_success
    }
  }
''';

const String GET_UPCOMING_LAUNCHES_QUERY = '''
  query GetUpcomingLaunches(\$limit: Int, \$offset: Int) {
    launchesUpcoming(limit: \$limit, offset: \$offset) {
      id
      mission_name
      launch_date_utc
      rocket {
        rocket_name
        rocket_type
      }
      launch_site {
        site_name_long
      }
      details
      links {
        article_link
        video_link
      }
      upcoming
    }
  }
''';

// Rockets
const String GET_ROCKETS_QUERY = '''
  query GetRockets {
    rockets {
      id
      name
      type
      active
      stages
      boosters
      cost_per_launch
      success_rate_pct
      first_flight
      country
      company
      description
      height {
        meters
        feet
      }
      diameter {
        meters
        feet
      }
      mass {
        kg
        lb
      }
      engines {
        number
        type
        version
        layout
        engine_loss_max
        propellant_1
        propellant_2
        thrust_sea_level {
          kN
          lbf
        }
        thrust_vacuum {
          kN
          lbf
        }
        thrust_to_weight
      }
      landing_legs {
        number
        material
      }
    }
  }
''';

const String GET_ROCKET_DETAILS_QUERY = '''
  query GetRocketDetails(\$id: ID!) {
    rocket(id: \$id) {
      id
      name
      type
      active
      stages
      boosters
      cost_per_launch
      success_rate_pct
      first_flight
      country
      company
      description
      height {
        meters
        feet
      }
      diameter {
        meters
        feet
      }
      mass {
        kg
        lb
      }
      engines {
        number
        type
        version
        layout
        engine_loss_max
        propellant_1
        propellant_2
        thrust_sea_level {
          kN
          lbf
        }
        thrust_vacuum {
          kN
          lbf
        }
        thrust_to_weight
      }
      landing_legs {
        number
        material
      }
    }
  }
''';

// Company
const String GET_COMPANY_QUERY = '''
  query GetCompany {
    company {
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