// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_rocket_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphQLRocket _$GraphQLRocketFromJson(Map<String, dynamic> json) =>
    GraphQLRocket(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      active: json['active'] as bool,
      stages: (json['stages'] as num).toInt(),
      boosters: (json['boosters'] as num).toInt(),
      costPerLaunch: (json['cost_per_launch'] as num).toInt(),
      successRatePct: (json['success_rate_pct'] as num).toInt(),
      firstFlight: json['first_flight'] as String,
      country: json['country'] as String,
      company: json['company'] as String,
      description: json['description'] as String,
      height:
          GraphQLRocketHeight.fromJson(json['height'] as Map<String, dynamic>),
      diameter: GraphQLRocketDiameter.fromJson(
          json['diameter'] as Map<String, dynamic>),
      mass: GraphQLRocketMass.fromJson(json['mass'] as Map<String, dynamic>),
      payloadWeights: (json['payload_weights'] as List<dynamic>?)
          ?.map((e) => GraphQLPayloadWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
      engines: json['engines'] == null
          ? null
          : GraphQLRocketEngines.fromJson(
              json['engines'] as Map<String, dynamic>),
      landingLegs: json['landing_legs'] == null
          ? null
          : GraphQLLandingLegs.fromJson(
              json['landing_legs'] as Map<String, dynamic>),
      firstStage: json['first_stage'] == null
          ? null
          : GraphQLFirstStage.fromJson(
              json['first_stage'] as Map<String, dynamic>),
      secondStage: json['second_stage'] == null
          ? null
          : GraphQLSecondStage.fromJson(
              json['second_stage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraphQLRocketToJson(GraphQLRocket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'active': instance.active,
      'stages': instance.stages,
      'boosters': instance.boosters,
      'cost_per_launch': instance.costPerLaunch,
      'success_rate_pct': instance.successRatePct,
      'first_flight': instance.firstFlight,
      'country': instance.country,
      'company': instance.company,
      'description': instance.description,
      'height': instance.height,
      'diameter': instance.diameter,
      'mass': instance.mass,
      'payload_weights': instance.payloadWeights,
      'engines': instance.engines,
      'landing_legs': instance.landingLegs,
      'first_stage': instance.firstStage,
      'second_stage': instance.secondStage,
    };

GraphQLRocketHeight _$GraphQLRocketHeightFromJson(Map<String, dynamic> json) =>
    GraphQLRocketHeight(
      meters: (json['meters'] as num?)?.toDouble(),
      feet: (json['feet'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GraphQLRocketHeightToJson(
        GraphQLRocketHeight instance) =>
    <String, dynamic>{
      'meters': instance.meters,
      'feet': instance.feet,
    };

GraphQLRocketDiameter _$GraphQLRocketDiameterFromJson(
        Map<String, dynamic> json) =>
    GraphQLRocketDiameter(
      meters: (json['meters'] as num?)?.toDouble(),
      feet: (json['feet'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GraphQLRocketDiameterToJson(
        GraphQLRocketDiameter instance) =>
    <String, dynamic>{
      'meters': instance.meters,
      'feet': instance.feet,
    };

GraphQLRocketMass _$GraphQLRocketMassFromJson(Map<String, dynamic> json) =>
    GraphQLRocketMass(
      kg: (json['kg'] as num?)?.toInt(),
      lb: (json['lb'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GraphQLRocketMassToJson(GraphQLRocketMass instance) =>
    <String, dynamic>{
      'kg': instance.kg,
      'lb': instance.lb,
    };

GraphQLPayloadWeight _$GraphQLPayloadWeightFromJson(
        Map<String, dynamic> json) =>
    GraphQLPayloadWeight(
      id: json['id'] as String,
      name: json['name'] as String,
      kg: (json['kg'] as num).toInt(),
      lb: (json['lb'] as num).toInt(),
    );

Map<String, dynamic> _$GraphQLPayloadWeightToJson(
        GraphQLPayloadWeight instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kg': instance.kg,
      'lb': instance.lb,
    };

GraphQLRocketEngines _$GraphQLRocketEnginesFromJson(
        Map<String, dynamic> json) =>
    GraphQLRocketEngines(
      number: (json['number'] as num).toInt(),
      type: json['type'] as String,
      version: json['version'] as String,
      layout: json['layout'] as String?,
      engineLossMax: json['engine_loss_max'] as String?,
      propellant1: json['propellant_1'] as String,
      propellant2: json['propellant_2'] as String,
      thrustSeaLevel: GraphQLThrust.fromJson(
          json['thrust_sea_level'] as Map<String, dynamic>),
      thrustVacuum:
          GraphQLThrust.fromJson(json['thrust_vacuum'] as Map<String, dynamic>),
      thrustToWeight: (json['thrust_to_weight'] as num).toDouble(),
    );

Map<String, dynamic> _$GraphQLRocketEnginesToJson(
        GraphQLRocketEngines instance) =>
    <String, dynamic>{
      'number': instance.number,
      'type': instance.type,
      'version': instance.version,
      'layout': instance.layout,
      'engine_loss_max': instance.engineLossMax,
      'propellant_1': instance.propellant1,
      'propellant_2': instance.propellant2,
      'thrust_sea_level': instance.thrustSeaLevel,
      'thrust_vacuum': instance.thrustVacuum,
      'thrust_to_weight': instance.thrustToWeight,
    };

GraphQLThrust _$GraphQLThrustFromJson(Map<String, dynamic> json) =>
    GraphQLThrust(
      kN: (json['kN'] as num).toInt(),
      lbf: (json['lbf'] as num).toInt(),
    );

Map<String, dynamic> _$GraphQLThrustToJson(GraphQLThrust instance) =>
    <String, dynamic>{
      'kN': instance.kN,
      'lbf': instance.lbf,
    };

GraphQLLandingLegs _$GraphQLLandingLegsFromJson(Map<String, dynamic> json) =>
    GraphQLLandingLegs(
      number: (json['number'] as num).toInt(),
      material: json['material'] as String?,
    );

Map<String, dynamic> _$GraphQLLandingLegsToJson(GraphQLLandingLegs instance) =>
    <String, dynamic>{
      'number': instance.number,
      'material': instance.material,
    };

GraphQLFirstStage _$GraphQLFirstStageFromJson(Map<String, dynamic> json) =>
    GraphQLFirstStage(
      reusable: json['reusable'] as bool,
      engines: (json['engines'] as num).toInt(),
      fuelAmountTons: (json['fuel_amount_tons'] as num).toDouble(),
      burnTimeSec: (json['burn_time_sec'] as num?)?.toInt(),
      thrustSeaLevel: GraphQLThrust.fromJson(
          json['thrust_sea_level'] as Map<String, dynamic>),
      thrustVacuum:
          GraphQLThrust.fromJson(json['thrust_vacuum'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraphQLFirstStageToJson(GraphQLFirstStage instance) =>
    <String, dynamic>{
      'reusable': instance.reusable,
      'engines': instance.engines,
      'fuel_amount_tons': instance.fuelAmountTons,
      'burn_time_sec': instance.burnTimeSec,
      'thrust_sea_level': instance.thrustSeaLevel,
      'thrust_vacuum': instance.thrustVacuum,
    };

GraphQLSecondStage _$GraphQLSecondStageFromJson(Map<String, dynamic> json) =>
    GraphQLSecondStage(
      reusable: json['reusable'] as bool,
      engines: (json['engines'] as num).toInt(),
      fuelAmountTons: (json['fuel_amount_tons'] as num).toDouble(),
      burnTimeSec: (json['burn_time_sec'] as num?)?.toInt(),
      thrust: GraphQLThrust.fromJson(json['thrust'] as Map<String, dynamic>),
      payloads:
          GraphQLPayloads.fromJson(json['payloads'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraphQLSecondStageToJson(GraphQLSecondStage instance) =>
    <String, dynamic>{
      'reusable': instance.reusable,
      'engines': instance.engines,
      'fuel_amount_tons': instance.fuelAmountTons,
      'burn_time_sec': instance.burnTimeSec,
      'thrust': instance.thrust,
      'payloads': instance.payloads,
    };

GraphQLPayloads _$GraphQLPayloadsFromJson(Map<String, dynamic> json) =>
    GraphQLPayloads(
      option1: json['option_1'] as String,
      compositeFairing: GraphQLCompositeFairing.fromJson(
          json['composite_fairing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraphQLPayloadsToJson(GraphQLPayloads instance) =>
    <String, dynamic>{
      'option_1': instance.option1,
      'composite_fairing': instance.compositeFairing,
    };

GraphQLCompositeFairing _$GraphQLCompositeFairingFromJson(
        Map<String, dynamic> json) =>
    GraphQLCompositeFairing(
      height:
          GraphQLRocketHeight.fromJson(json['height'] as Map<String, dynamic>),
      diameter: GraphQLRocketDiameter.fromJson(
          json['diameter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraphQLCompositeFairingToJson(
        GraphQLCompositeFairing instance) =>
    <String, dynamic>{
      'height': instance.height,
      'diameter': instance.diameter,
    };
