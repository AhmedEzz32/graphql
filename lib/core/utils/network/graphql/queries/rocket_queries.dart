const String GET_ROCKETS_QUERY = '''
  query GetRockets(\$limit: Int, \$offset: Int) {
    rockets(limit: \$limit, offset: \$offset) {
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
      wikipedia
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
      wikipedia
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
      payload_weights {
        id
        name
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
      first_stage {
        reusable
        engines
        fuel_amount_tons
        burn_time_sec
        thrust_sea_level {
          kN
          lbf
        }
        thrust_vacuum {
          kN
          lbf
        }
      }
      second_stage {
        reusable
        engines
        fuel_amount_tons
        burn_time_sec
        thrust {
          kN
          lbf
        }
        payloads {
          option_1
          composite_fairing {
            height {
              meters
              feet
            }
            diameter {
              meters
              feet
            }
          }
        }
      }
    }
  }
''';

const String SEARCH_ROCKETS_QUERY = '''
  query SearchRockets(\$limit: Int, \$offset: Int) {
    rockets(limit: \$limit, offset: \$offset) {
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
      wikipedia
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
    }
  }
''';
