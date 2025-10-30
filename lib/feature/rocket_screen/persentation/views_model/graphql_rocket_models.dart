import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graphql_rocket_models.g.dart';

@JsonSerializable()
class GraphQLRocket extends Equatable {
  final String id;
  final String name;
  final String type;
  final bool active;
  final int stages;
  final int boosters;
  @JsonKey(name: 'cost_per_launch')
  final int costPerLaunch;
  @JsonKey(name: 'success_rate_pct')
  final int successRatePct;
  @JsonKey(name: 'first_flight')
  final String firstFlight;
  final String country;
  final String company;
  final String description;
  final GraphQLRocketHeight height;
  final GraphQLRocketDiameter diameter;
  final GraphQLRocketMass mass;
  @JsonKey(name: 'payload_weights')
  final List<GraphQLPayloadWeight>? payloadWeights;
  final GraphQLRocketEngines? engines;
  @JsonKey(name: 'landing_legs')
  final GraphQLLandingLegs? landingLegs;
  @JsonKey(name: 'first_stage')
  final GraphQLFirstStage? firstStage;
  @JsonKey(name: 'second_stage')
  final GraphQLSecondStage? secondStage;

  const GraphQLRocket({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.stages,
    required this.boosters,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.firstFlight,
    required this.country,
    required this.company,
    required this.description,
    required this.height,
    required this.diameter,
    required this.mass,
    this.payloadWeights,
    this.engines,
    this.landingLegs,
    this.firstStage,
    this.secondStage,
  });

  factory GraphQLRocket.fromJson(Map<String, dynamic> json) =>
      _$GraphQLRocketFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLRocketToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        active,
        stages,
        boosters,
        costPerLaunch,
        successRatePct,
        firstFlight,
        country,
        company,
        description,
        height,
        diameter,
        mass,
        payloadWeights,
        engines,
        landingLegs,
        firstStage,
        secondStage,
      ];
}

@JsonSerializable()
class GraphQLRocketHeight extends Equatable {
  final double? meters;
  final double? feet;

  const GraphQLRocketHeight({
    this.meters,
    this.feet,
  });

  factory GraphQLRocketHeight.fromJson(Map<String, dynamic> json) =>
      _$GraphQLRocketHeightFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLRocketHeightToJson(this);

  @override
  List<Object?> get props => [meters, feet];
}

@JsonSerializable()
class GraphQLRocketDiameter extends Equatable {
  final double? meters;
  final double? feet;

  const GraphQLRocketDiameter({
    this.meters,
    this.feet,
  });

  factory GraphQLRocketDiameter.fromJson(Map<String, dynamic> json) =>
      _$GraphQLRocketDiameterFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLRocketDiameterToJson(this);

  @override
  List<Object?> get props => [meters, feet];
}

@JsonSerializable()
class GraphQLRocketMass extends Equatable {
  final int? kg;
  final int? lb;

  const GraphQLRocketMass({
    this.kg,
    this.lb,
  });

  factory GraphQLRocketMass.fromJson(Map<String, dynamic> json) =>
      _$GraphQLRocketMassFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLRocketMassToJson(this);

  @override
  List<Object?> get props => [kg, lb];
}

@JsonSerializable()
class GraphQLPayloadWeight extends Equatable {
  final String id;
  final String name;
  final int kg;
  final int lb;

  const GraphQLPayloadWeight({
    required this.id,
    required this.name,
    required this.kg,
    required this.lb,
  });

  factory GraphQLPayloadWeight.fromJson(Map<String, dynamic> json) =>
      _$GraphQLPayloadWeightFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLPayloadWeightToJson(this);

  @override
  List<Object?> get props => [id, name, kg, lb];
}

@JsonSerializable()
class GraphQLRocketEngines extends Equatable {
  final int number;
  final String type;
  final String version;
  final String? layout;
  @JsonKey(name: 'engine_loss_max')
  final String? engineLossMax;
  @JsonKey(name: 'propellant_1')
  final String propellant1;
  @JsonKey(name: 'propellant_2')
  final String propellant2;
  @JsonKey(name: 'thrust_sea_level')
  final GraphQLThrust thrustSeaLevel;
  @JsonKey(name: 'thrust_vacuum')
  final GraphQLThrust thrustVacuum;
  @JsonKey(name: 'thrust_to_weight')
  final double thrustToWeight;

  const GraphQLRocketEngines({
    required this.number,
    required this.type,
    required this.version,
    this.layout,
    this.engineLossMax,
    required this.propellant1,
    required this.propellant2,
    required this.thrustSeaLevel,
    required this.thrustVacuum,
    required this.thrustToWeight,
  });

  factory GraphQLRocketEngines.fromJson(Map<String, dynamic> json) =>
      _$GraphQLRocketEnginesFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLRocketEnginesToJson(this);

  @override
  List<Object?> get props => [
        number,
        type,
        version,
        layout,
        engineLossMax,
        propellant1,
        propellant2,
        thrustSeaLevel,
        thrustVacuum,
        thrustToWeight,
      ];
}

@JsonSerializable()
class GraphQLThrust extends Equatable {
  @JsonKey(name: 'kN')
  final int kN;
  final int lbf;

  const GraphQLThrust({
    required this.kN,
    required this.lbf,
  });

  factory GraphQLThrust.fromJson(Map<String, dynamic> json) =>
      _$GraphQLThrustFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLThrustToJson(this);

  @override
  List<Object?> get props => [kN, lbf];
}

@JsonSerializable()
class GraphQLLandingLegs extends Equatable {
  final int number;
  final String? material;

  const GraphQLLandingLegs({
    required this.number,
    this.material,
  });

  factory GraphQLLandingLegs.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLandingLegsFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLandingLegsToJson(this);

  @override
  List<Object?> get props => [number, material];
}

@JsonSerializable()
class GraphQLFirstStage extends Equatable {
  final bool reusable;
  final int engines;
  @JsonKey(name: 'fuel_amount_tons')
  final double fuelAmountTons;
  @JsonKey(name: 'burn_time_sec')
  final int? burnTimeSec;
  @JsonKey(name: 'thrust_sea_level')
  final GraphQLThrust thrustSeaLevel;
  @JsonKey(name: 'thrust_vacuum')
  final GraphQLThrust thrustVacuum;

  const GraphQLFirstStage({
    required this.reusable,
    required this.engines,
    required this.fuelAmountTons,
    this.burnTimeSec,
    required this.thrustSeaLevel,
    required this.thrustVacuum,
  });

  factory GraphQLFirstStage.fromJson(Map<String, dynamic> json) =>
      _$GraphQLFirstStageFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLFirstStageToJson(this);

  @override
  List<Object?> get props => [
        reusable,
        engines,
        fuelAmountTons,
        burnTimeSec,
        thrustSeaLevel,
        thrustVacuum,
      ];
}

@JsonSerializable()
class GraphQLSecondStage extends Equatable {
  final bool reusable;
  final int engines;
  @JsonKey(name: 'fuel_amount_tons')
  final double fuelAmountTons;
  @JsonKey(name: 'burn_time_sec')
  final int? burnTimeSec;
  final GraphQLThrust thrust;
  final GraphQLPayloads payloads;

  const GraphQLSecondStage({
    required this.reusable,
    required this.engines,
    required this.fuelAmountTons,
    this.burnTimeSec,
    required this.thrust,
    required this.payloads,
  });

  factory GraphQLSecondStage.fromJson(Map<String, dynamic> json) =>
      _$GraphQLSecondStageFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLSecondStageToJson(this);

  @override
  List<Object?> get props => [
        reusable,
        engines,
        fuelAmountTons,
        burnTimeSec,
        thrust,
        payloads,
      ];
}

@JsonSerializable()
class GraphQLPayloads extends Equatable {
  @JsonKey(name: 'option_1')
  final String option1;
  @JsonKey(name: 'composite_fairing')
  final GraphQLCompositeFairing compositeFairing;

  const GraphQLPayloads({
    required this.option1,
    required this.compositeFairing,
  });

  factory GraphQLPayloads.fromJson(Map<String, dynamic> json) =>
      _$GraphQLPayloadsFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLPayloadsToJson(this);

  @override
  List<Object?> get props => [option1, compositeFairing];
}

@JsonSerializable()
class GraphQLCompositeFairing extends Equatable {
  final GraphQLRocketHeight height;
  final GraphQLRocketDiameter diameter;

  const GraphQLCompositeFairing({
    required this.height,
    required this.diameter,
  });

  factory GraphQLCompositeFairing.fromJson(Map<String, dynamic> json) =>
      _$GraphQLCompositeFairingFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLCompositeFairingToJson(this);

  @override
  List<Object?> get props => [height, diameter];
}
