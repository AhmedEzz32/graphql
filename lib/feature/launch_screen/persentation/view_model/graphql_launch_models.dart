import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graphql_launch_models.g.dart';

@JsonSerializable()
class GraphQLLaunch extends Equatable {
  final String id;
  @JsonKey(name: 'date_utc')
  final String? dateUtc;
  @JsonKey(name: 'date_local')
  final String? dateLocal;
  final bool? success;
  final bool upcoming;
  final String? details;
  @JsonKey(name: 'flight_number')
  final int flightNumber;
  @JsonKey(name: 'static_fire_date_utc')
  final String? staticFireDateUtc;
  @JsonKey(name: 'tentative_max_precision')
  final String? tentativeMaxPrecision;
  final bool? tbd;
  final GraphQLLaunchRocket rocket;
  final GraphQLLaunchpad? launchpad; // Changed from launch_site
  final GraphQLLaunchLinks links;
  @JsonKey(name: 'launch_failure_details')
  final GraphQLLaunchFailureDetails? launchFailureDetails;
  final GraphQLTimeline? timeline;
  final List<GraphQLShip>? ships;

  const GraphQLLaunch({
    required this.id,
    this.dateUtc,
    this.dateLocal,
    this.success,
    required this.upcoming,
    this.details,
    required this.flightNumber,
    this.staticFireDateUtc,
    this.tentativeMaxPrecision,
    this.tbd,
    required this.rocket,
    this.launchpad,
    required this.links,
    this.launchFailureDetails,
    this.timeline,
    this.ships,
  });

  factory GraphQLLaunch.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchToJson(this);

  @override
  List<Object?> get props => [
        id,
        dateUtc,
        dateLocal,
        success,
        upcoming,
        details,
        flightNumber,
        staticFireDateUtc,
        tentativeMaxPrecision,
        tbd,
        rocket,
        launchpad,
        links,
        launchFailureDetails,
        timeline,
        ships,
      ];
}

@JsonSerializable()
class GraphQLLaunchRocket extends Equatable {
  final String id;
  final String name;
  final String type;
  @JsonKey(name: 'first_stage')
  final GraphQLLaunchFirstStage? firstStage;
  @JsonKey(name: 'second_stage')
  final GraphQLLaunchSecondStage? secondStage;
  final GraphQLFairings? fairings;

  const GraphQLLaunchRocket({
    required this.id,
    required this.name,
    required this.type,
    this.firstStage,
    this.secondStage,
    this.fairings,
  });

  factory GraphQLLaunchRocket.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchRocketFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchRocketToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        firstStage,
        secondStage,
        fairings,
      ];
}

@JsonSerializable()
class GraphQLLaunchpad extends Equatable {
  final String id;
  final String? name;
  @JsonKey(name: 'full_name')
  final String? fullName;

  const GraphQLLaunchpad({
    required this.id,
    this.name,
    this.fullName,
  });

  factory GraphQLLaunchpad.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchpadFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchpadToJson(this);

  @override
  List<Object?> get props => [id, name, fullName];
}

@JsonSerializable()
class GraphQLLaunchLinks extends Equatable {
  final GraphQLPatch? patch;
  final GraphQLReddit? reddit;
  final GraphQLFlickr? flickr;
  final String? webcast;
  @JsonKey(name: 'youtube_id')
  final String? youtubeId;
  final String? article;
  final String? wikipedia;

  const GraphQLLaunchLinks({
    this.patch,
    this.reddit,
    this.flickr,
    this.webcast,
    this.youtubeId,
    this.article,
    this.wikipedia,
  });

  factory GraphQLLaunchLinks.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchLinksFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchLinksToJson(this);

  @override
  List<Object?> get props => [
        patch,
        reddit,
        flickr,
        webcast,
        youtubeId,
        article,
        wikipedia,
      ];
}

@JsonSerializable()
class GraphQLPatch extends Equatable {
  final String? small;
  final String? large;

  const GraphQLPatch({
    this.small,
    this.large,
  });

  factory GraphQLPatch.fromJson(Map<String, dynamic> json) =>
      _$GraphQLPatchFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLPatchToJson(this);

  @override
  List<Object?> get props => [small, large];
}

@JsonSerializable()
class GraphQLReddit extends Equatable {
  final String? campaign;
  final String? launch;
  final String? media;
  final String? recovery;

  const GraphQLReddit({
    this.campaign,
    this.launch,
    this.media,
    this.recovery,
  });

  factory GraphQLReddit.fromJson(Map<String, dynamic> json) =>
      _$GraphQLRedditFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLRedditToJson(this);

  @override
  List<Object?> get props => [campaign, launch, media, recovery];
}

@JsonSerializable()
class GraphQLFlickr extends Equatable {
  final List<String>? small;
  final List<String>? original;

  const GraphQLFlickr({
    this.small,
    this.original,
  });

  factory GraphQLFlickr.fromJson(Map<String, dynamic> json) =>
      _$GraphQLFlickrFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLFlickrToJson(this);

  @override
  List<Object?> get props => [small, original];
}

@JsonSerializable()
class GraphQLLaunchFailureDetails extends Equatable {
  final int time;
  final int? altitude;
  final String reason;

  const GraphQLLaunchFailureDetails({
    required this.time,
    this.altitude,
    required this.reason,
  });

  factory GraphQLLaunchFailureDetails.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchFailureDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchFailureDetailsToJson(this);

  @override
  List<Object?> get props => [time, altitude, reason];
}

@JsonSerializable()
class GraphQLTimeline extends Equatable {
  @JsonKey(name: 'webcast_liftoff')
  final int? webcastLiftoff;
  @JsonKey(name: 'go_for_prop_loading')
  final int? goForPropLoading;
  @JsonKey(name: 'rp1_loading')
  final int? rp1Loading;
  @JsonKey(name: 'stage1_lox_loading')
  final int? stage1LoxLoading;
  @JsonKey(name: 'stage2_lox_loading')
  final int? stage2LoxLoading;
  @JsonKey(name: 'engine_chill')
  final int? engineChill;
  @JsonKey(name: 'prelaunch_checks')
  final int? prelaunchChecks;
  @JsonKey(name: 'propellant_pressurization')
  final int? propellantPressurization;
  @JsonKey(name: 'go_for_launch')
  final int? goForLaunch;
  final int? ignition;
  final int? liftoff;
  final int? maxq;
  final int? meco;
  @JsonKey(name: 'stage_sep')
  final int? stageSep;
  @JsonKey(name: 'second_stage_ignition')
  final int? secondStageIgnition;
  @JsonKey(name: 'fairing_deploy')
  final int? fairingDeploy;
  @JsonKey(name: 'first_stage_entry_burn')
  final int? firstStageEntryBurn;
  final int? seco1;
  @JsonKey(name: 'first_stage_landing')
  final int? firstStageLanding;
  @JsonKey(name: 'second_stage_restart')
  final int? secondStageRestart;
  final int? seco2;
  @JsonKey(name: 'payload_deploy')
  final int? payloadDeploy;

  const GraphQLTimeline({
    this.webcastLiftoff,
    this.goForPropLoading,
    this.rp1Loading,
    this.stage1LoxLoading,
    this.stage2LoxLoading,
    this.engineChill,
    this.prelaunchChecks,
    this.propellantPressurization,
    this.goForLaunch,
    this.ignition,
    this.liftoff,
    this.maxq,
    this.meco,
    this.stageSep,
    this.secondStageIgnition,
    this.fairingDeploy,
    this.firstStageEntryBurn,
    this.seco1,
    this.firstStageLanding,
    this.secondStageRestart,
    this.seco2,
    this.payloadDeploy,
  });

  factory GraphQLTimeline.fromJson(Map<String, dynamic> json) =>
      _$GraphQLTimelineFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLTimelineToJson(this);

  @override
  List<Object?> get props => [
        webcastLiftoff,
        goForPropLoading,
        rp1Loading,
        stage1LoxLoading,
        stage2LoxLoading,
        engineChill,
        prelaunchChecks,
        propellantPressurization,
        goForLaunch,
        ignition,
        liftoff,
        maxq,
        meco,
        stageSep,
        secondStageIgnition,
        fairingDeploy,
        firstStageEntryBurn,
        seco1,
        firstStageLanding,
        secondStageRestart,
        seco2,
        payloadDeploy,
      ];
}

// Additional models for complete launch data
@JsonSerializable()
class GraphQLLaunchFirstStage extends Equatable {
  final List<GraphQLCore> cores;

  const GraphQLLaunchFirstStage({
    required this.cores,
  });

  factory GraphQLLaunchFirstStage.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchFirstStageFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchFirstStageToJson(this);

  @override
  List<Object?> get props => [cores];
}

@JsonSerializable()
class GraphQLCore extends Equatable {
  @JsonKey(name: 'core_serial')
  final String? coreSerial;
  final int? flight;
  final int? block;
  final bool? gridfins;
  final bool? legs;
  final bool? reused;
  @JsonKey(name: 'land_success')
  final bool? landSuccess;
  @JsonKey(name: 'landing_intent')
  final bool? landingIntent;
  @JsonKey(name: 'landing_type')
  final String? landingType;
  @JsonKey(name: 'landing_vehicle')
  final String? landingVehicle;

  const GraphQLCore({
    this.coreSerial,
    this.flight,
    this.block,
    this.gridfins,
    this.legs,
    this.reused,
    this.landSuccess,
    this.landingIntent,
    this.landingType,
    this.landingVehicle,
  });

  factory GraphQLCore.fromJson(Map<String, dynamic> json) =>
      _$GraphQLCoreFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLCoreToJson(this);

  @override
  List<Object?> get props => [
        coreSerial,
        flight,
        block,
        gridfins,
        legs,
        reused,
        landSuccess,
        landingIntent,
        landingType,
        landingVehicle,
      ];
}

@JsonSerializable()
class GraphQLLaunchSecondStage extends Equatable {
  final int? block;
  final List<GraphQLLaunchPayload> payloads;

  const GraphQLLaunchSecondStage({
    this.block,
    required this.payloads,
  });

  factory GraphQLLaunchSecondStage.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchSecondStageFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchSecondStageToJson(this);

  @override
  List<Object?> get props => [block, payloads];
}

@JsonSerializable()
class GraphQLLaunchPayload extends Equatable {
  @JsonKey(name: 'payload_id')
  final String payloadId;
  @JsonKey(name: 'norad_id')
  final List<int>? noradId;
  final bool? reused;
  final List<String> customers;
  final String nationality;
  final String manufacturer;
  @JsonKey(name: 'payload_type')
  final String payloadType;
  @JsonKey(name: 'payload_mass_kg')
  final double? payloadMassKg;
  @JsonKey(name: 'payload_mass_lbs')
  final double? payloadMassLbs;
  final String orbit;
  @JsonKey(name: 'orbit_params')
  final GraphQLOrbitParams? orbitParams;

  const GraphQLLaunchPayload({
    required this.payloadId,
    this.noradId,
    this.reused,
    required this.customers,
    required this.nationality,
    required this.manufacturer,
    required this.payloadType,
    this.payloadMassKg,
    this.payloadMassLbs,
    required this.orbit,
    this.orbitParams,
  });

  factory GraphQLLaunchPayload.fromJson(Map<String, dynamic> json) =>
      _$GraphQLLaunchPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLLaunchPayloadToJson(this);

  @override
  List<Object?> get props => [
        payloadId,
        noradId,
        reused,
        customers,
        nationality,
        manufacturer,
        payloadType,
        payloadMassKg,
        payloadMassLbs,
        orbit,
        orbitParams,
      ];
}

@JsonSerializable()
class GraphQLOrbitParams extends Equatable {
  @JsonKey(name: 'reference_system')
  final String? referenceSystem;
  final String? regime;
  final double? longitude;
  @JsonKey(name: 'semi_major_axis_km')
  final double? semiMajorAxisKm;
  final double? eccentricity;
  @JsonKey(name: 'periapsis_km')
  final double? periapsisKm;
  @JsonKey(name: 'apoapsis_km')
  final double? apoapsisKm;
  @JsonKey(name: 'inclination_deg')
  final double? inclinationDeg;
  @JsonKey(name: 'period_min')
  final double? periodMin;
  @JsonKey(name: 'lifespan_years')
  final int? lifespanYears;
  final String? epoch;
  @JsonKey(name: 'mean_motion')
  final double? meanMotion;
  final double? raan;
  @JsonKey(name: 'arg_of_pericenter')
  final double? argOfPericenter;
  @JsonKey(name: 'mean_anomaly')
  final double? meanAnomaly;

  const GraphQLOrbitParams({
    this.referenceSystem,
    this.regime,
    this.longitude,
    this.semiMajorAxisKm,
    this.eccentricity,
    this.periapsisKm,
    this.apoapsisKm,
    this.inclinationDeg,
    this.periodMin,
    this.lifespanYears,
    this.epoch,
    this.meanMotion,
    this.raan,
    this.argOfPericenter,
    this.meanAnomaly,
  });

  factory GraphQLOrbitParams.fromJson(Map<String, dynamic> json) =>
      _$GraphQLOrbitParamsFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLOrbitParamsToJson(this);

  @override
  List<Object?> get props => [
        referenceSystem,
        regime,
        longitude,
        semiMajorAxisKm,
        eccentricity,
        periapsisKm,
        apoapsisKm,
        inclinationDeg,
        periodMin,
        lifespanYears,
        epoch,
        meanMotion,
        raan,
        argOfPericenter,
        meanAnomaly,
      ];
}

@JsonSerializable()
class GraphQLFairings extends Equatable {
  final bool? reused;
  @JsonKey(name: 'recovery_attempt')
  final bool? recoveryAttempt;
  final bool? recovered;
  final String? ship;

  const GraphQLFairings({
    this.reused,
    this.recoveryAttempt,
    this.recovered,
    this.ship,
  });

  factory GraphQLFairings.fromJson(Map<String, dynamic> json) =>
      _$GraphQLFairingsFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLFairingsToJson(this);

  @override
  List<Object?> get props => [reused, recoveryAttempt, recovered, ship];
}

@JsonSerializable()
class GraphQLShip extends Equatable {
  final String id;
  final String name;
  final String? type;
  final List<String>? roles;
  final bool active;
  final int? imo;
  final int? mmsi;
  final int? abs;
  @JsonKey(name: 'class')
  final int? shipClass;
  @JsonKey(name: 'mass_kg')
  final int? massKg;
  @JsonKey(name: 'mass_lbs')
  final int? massLbs;
  @JsonKey(name: 'year_built')
  final int? yearBuilt;
  @JsonKey(name: 'home_port')
  final String? homePort;
  final String? status;
  @JsonKey(name: 'speed_kn')
  final double? speedKn;
  @JsonKey(name: 'course_deg')
  final double? courseDeg;
  final GraphQLPosition? position;
  @JsonKey(name: 'successful_landings')
  final int? successfulLandings;
  @JsonKey(name: 'attempted_landings')
  final int? attemptedLandings;
  final List<GraphQLMission>? missions;
  final String? url;
  final String? image;

  const GraphQLShip({
    required this.id,
    required this.name,
    this.type,
    this.roles,
    required this.active,
    this.imo,
    this.mmsi,
    this.abs,
    this.shipClass,
    this.massKg,
    this.massLbs,
    this.yearBuilt,
    this.homePort,
    this.status,
    this.speedKn,
    this.courseDeg,
    this.position,
    this.successfulLandings,
    this.attemptedLandings,
    this.missions,
    this.url,
    this.image,
  });

  factory GraphQLShip.fromJson(Map<String, dynamic> json) =>
      _$GraphQLShipFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLShipToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        roles,
        active,
        imo,
        mmsi,
        abs,
        shipClass,
        massKg,
        massLbs,
        yearBuilt,
        homePort,
        status,
        speedKn,
        courseDeg,
        position,
        successfulLandings,
        attemptedLandings,
        missions,
        url,
        image,
      ];
}

@JsonSerializable()
class GraphQLPosition extends Equatable {
  final double latitude;
  final double longitude;

  const GraphQLPosition({
    required this.latitude,
    required this.longitude,
  });

  factory GraphQLPosition.fromJson(Map<String, dynamic> json) =>
      _$GraphQLPositionFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLPositionToJson(this);

  @override
  List<Object?> get props => [latitude, longitude];
}

@JsonSerializable()
class GraphQLMission extends Equatable {
  final String name;
  final int flight;

  const GraphQLMission({
    required this.name,
    required this.flight,
  });

  factory GraphQLMission.fromJson(Map<String, dynamic> json) =>
      _$GraphQLMissionFromJson(json);

  Map<String, dynamic> toJson() => _$GraphQLMissionToJson(this);

  @override
  List<Object?> get props => [name, flight];
}
