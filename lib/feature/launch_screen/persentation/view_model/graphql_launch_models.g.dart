// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_launch_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphQLLaunch _$GraphQLLaunchFromJson(Map<String, dynamic> json) =>
    GraphQLLaunch(
      id: json['id'] as String,
      missionName: json['mission_name'] as String,
      launchDateUtc: json['launch_date_utc'] as String?,
      dateLocal: json['date_local'] as String?,
      success: json['launch_success'] as bool?,
      upcoming: json['upcoming'] as bool?,
      details: json['details'] as String?,
      staticFireDateUtc: json['static_fire_date_utc'] as String?,
      tentativeMaxPrecision: json['tentative_max_precision'] as String?,
      tbd: json['tbd'] as bool?,
      rocket:
          GraphQLLaunchRocket.fromJson(json['rocket'] as Map<String, dynamic>),
      launchpad: json['launch_site'] == null
          ? null
          : GraphQLLaunchpad.fromJson(
              json['launch_site'] as Map<String, dynamic>),
      links: GraphQLLaunchLinks.fromJson(json['links'] as Map<String, dynamic>),
      launchFailureDetails: json['launch_failure_details'] == null
          ? null
          : GraphQLLaunchFailureDetails.fromJson(
              json['launch_failure_details'] as Map<String, dynamic>),
      timeline: json['timeline'] == null
          ? null
          : GraphQLTimeline.fromJson(json['timeline'] as Map<String, dynamic>),
      ships: (json['ships'] as List<dynamic>?)
          ?.map((e) => GraphQLShip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GraphQLLaunchToJson(GraphQLLaunch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mission_name': instance.missionName,
      'launch_date_utc': instance.launchDateUtc,
      'date_local': instance.dateLocal,
      'launch_success': instance.success,
      'upcoming': instance.upcoming,
      'details': instance.details,
      'static_fire_date_utc': instance.staticFireDateUtc,
      'tentative_max_precision': instance.tentativeMaxPrecision,
      'tbd': instance.tbd,
      'rocket': instance.rocket,
      'launch_site': instance.launchpad,
      'links': instance.links,
      'launch_failure_details': instance.launchFailureDetails,
      'timeline': instance.timeline,
      'ships': instance.ships,
    };

GraphQLLaunchRocket _$GraphQLLaunchRocketFromJson(Map<String, dynamic> json) =>
    GraphQLLaunchRocket(
      name: json['rocket_name'] as String,
      type: json['rocket_type'] as String,
      firstStage: json['first_stage'] == null
          ? null
          : GraphQLLaunchFirstStage.fromJson(
              json['first_stage'] as Map<String, dynamic>),
      secondStage: json['second_stage'] == null
          ? null
          : GraphQLLaunchSecondStage.fromJson(
              json['second_stage'] as Map<String, dynamic>),
      fairings: json['fairings'] == null
          ? null
          : GraphQLFairings.fromJson(json['fairings'] as Map<String, dynamic>),
      rocket: json['rocket'] == null
          ? null
          : GraphQLRocket.fromJson(json['rocket'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraphQLLaunchRocketToJson(
        GraphQLLaunchRocket instance) =>
    <String, dynamic>{
      'rocket_name': instance.name,
      'rocket_type': instance.type,
      'first_stage': instance.firstStage,
      'second_stage': instance.secondStage,
      'fairings': instance.fairings,
      'rocket': instance.rocket,
    };

GraphQLLaunchpad _$GraphQLLaunchpadFromJson(Map<String, dynamic> json) =>
    GraphQLLaunchpad(
      id: json['id'] as String?,
      name: json['name'] as String?,
      fullName: json['site_name_long'] as String?,
    );

Map<String, dynamic> _$GraphQLLaunchpadToJson(GraphQLLaunchpad instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'site_name_long': instance.fullName,
    };

GraphQLLaunchLinks _$GraphQLLaunchLinksFromJson(Map<String, dynamic> json) =>
    GraphQLLaunchLinks(
      patch: json['patch'] == null
          ? null
          : GraphQLPatch.fromJson(json['patch'] as Map<String, dynamic>),
      reddit: json['reddit'] == null
          ? null
          : GraphQLReddit.fromJson(json['reddit'] as Map<String, dynamic>),
      flickr: json['flickr'] == null
          ? null
          : GraphQLFlickr.fromJson(json['flickr'] as Map<String, dynamic>),
      webcast: json['video_link'] as String?,
      youtubeId: json['youtube_id'] as String?,
      article: json['article_link'] as String?,
      wikipedia: json['wikipedia'] as String?,
    );

Map<String, dynamic> _$GraphQLLaunchLinksToJson(GraphQLLaunchLinks instance) =>
    <String, dynamic>{
      'patch': instance.patch,
      'reddit': instance.reddit,
      'flickr': instance.flickr,
      'video_link': instance.webcast,
      'youtube_id': instance.youtubeId,
      'article_link': instance.article,
      'wikipedia': instance.wikipedia,
    };

GraphQLPatch _$GraphQLPatchFromJson(Map<String, dynamic> json) => GraphQLPatch(
      small: json['small'] as String?,
      large: json['large'] as String?,
    );

Map<String, dynamic> _$GraphQLPatchToJson(GraphQLPatch instance) =>
    <String, dynamic>{
      'small': instance.small,
      'large': instance.large,
    };

GraphQLReddit _$GraphQLRedditFromJson(Map<String, dynamic> json) =>
    GraphQLReddit(
      campaign: json['campaign'] as String?,
      launch: json['launch'] as String?,
      media: json['media'] as String?,
      recovery: json['recovery'] as String?,
    );

Map<String, dynamic> _$GraphQLRedditToJson(GraphQLReddit instance) =>
    <String, dynamic>{
      'campaign': instance.campaign,
      'launch': instance.launch,
      'media': instance.media,
      'recovery': instance.recovery,
    };

GraphQLFlickr _$GraphQLFlickrFromJson(Map<String, dynamic> json) =>
    GraphQLFlickr(
      small:
          (json['small'] as List<dynamic>?)?.map((e) => e as String).toList(),
      original: (json['original'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GraphQLFlickrToJson(GraphQLFlickr instance) =>
    <String, dynamic>{
      'small': instance.small,
      'original': instance.original,
    };

GraphQLLaunchFailureDetails _$GraphQLLaunchFailureDetailsFromJson(
        Map<String, dynamic> json) =>
    GraphQLLaunchFailureDetails(
      time: (json['time'] as num).toInt(),
      altitude: (json['altitude'] as num?)?.toInt(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$GraphQLLaunchFailureDetailsToJson(
        GraphQLLaunchFailureDetails instance) =>
    <String, dynamic>{
      'time': instance.time,
      'altitude': instance.altitude,
      'reason': instance.reason,
    };

GraphQLTimeline _$GraphQLTimelineFromJson(Map<String, dynamic> json) =>
    GraphQLTimeline(
      webcastLiftoff: (json['webcast_liftoff'] as num?)?.toInt(),
      goForPropLoading: (json['go_for_prop_loading'] as num?)?.toInt(),
      rp1Loading: (json['rp1_loading'] as num?)?.toInt(),
      stage1LoxLoading: (json['stage1_lox_loading'] as num?)?.toInt(),
      stage2LoxLoading: (json['stage2_lox_loading'] as num?)?.toInt(),
      engineChill: (json['engine_chill'] as num?)?.toInt(),
      prelaunchChecks: (json['prelaunch_checks'] as num?)?.toInt(),
      propellantPressurization:
          (json['propellant_pressurization'] as num?)?.toInt(),
      goForLaunch: (json['go_for_launch'] as num?)?.toInt(),
      ignition: (json['ignition'] as num?)?.toInt(),
      liftoff: (json['liftoff'] as num?)?.toInt(),
      maxq: (json['maxq'] as num?)?.toInt(),
      meco: (json['meco'] as num?)?.toInt(),
      stageSep: (json['stage_sep'] as num?)?.toInt(),
      secondStageIgnition: (json['second_stage_ignition'] as num?)?.toInt(),
      fairingDeploy: (json['fairing_deploy'] as num?)?.toInt(),
      firstStageEntryBurn: (json['first_stage_entry_burn'] as num?)?.toInt(),
      seco1: (json['seco1'] as num?)?.toInt(),
      firstStageLanding: (json['first_stage_landing'] as num?)?.toInt(),
      secondStageRestart: (json['second_stage_restart'] as num?)?.toInt(),
      seco2: (json['seco2'] as num?)?.toInt(),
      payloadDeploy: (json['payload_deploy'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GraphQLTimelineToJson(GraphQLTimeline instance) =>
    <String, dynamic>{
      'webcast_liftoff': instance.webcastLiftoff,
      'go_for_prop_loading': instance.goForPropLoading,
      'rp1_loading': instance.rp1Loading,
      'stage1_lox_loading': instance.stage1LoxLoading,
      'stage2_lox_loading': instance.stage2LoxLoading,
      'engine_chill': instance.engineChill,
      'prelaunch_checks': instance.prelaunchChecks,
      'propellant_pressurization': instance.propellantPressurization,
      'go_for_launch': instance.goForLaunch,
      'ignition': instance.ignition,
      'liftoff': instance.liftoff,
      'maxq': instance.maxq,
      'meco': instance.meco,
      'stage_sep': instance.stageSep,
      'second_stage_ignition': instance.secondStageIgnition,
      'fairing_deploy': instance.fairingDeploy,
      'first_stage_entry_burn': instance.firstStageEntryBurn,
      'seco1': instance.seco1,
      'first_stage_landing': instance.firstStageLanding,
      'second_stage_restart': instance.secondStageRestart,
      'seco2': instance.seco2,
      'payload_deploy': instance.payloadDeploy,
    };

GraphQLLaunchFirstStage _$GraphQLLaunchFirstStageFromJson(
        Map<String, dynamic> json) =>
    GraphQLLaunchFirstStage(
      cores: (json['cores'] as List<dynamic>)
          .map((e) => GraphQLCore.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GraphQLLaunchFirstStageToJson(
        GraphQLLaunchFirstStage instance) =>
    <String, dynamic>{
      'cores': instance.cores,
    };

GraphQLCore _$GraphQLCoreFromJson(Map<String, dynamic> json) => GraphQLCore(
      coreSerial: json['core_serial'] as String?,
      flight: (json['flight'] as num?)?.toInt(),
      block: (json['block'] as num?)?.toInt(),
      gridfins: json['gridfins'] as bool?,
      legs: json['legs'] as bool?,
      reused: json['reused'] as bool?,
      landSuccess: json['land_success'] as bool?,
      landingIntent: json['landing_intent'] as bool?,
      landingType: json['landing_type'] as String?,
      landingVehicle: json['landing_vehicle'] as String?,
    );

Map<String, dynamic> _$GraphQLCoreToJson(GraphQLCore instance) =>
    <String, dynamic>{
      'core_serial': instance.coreSerial,
      'flight': instance.flight,
      'block': instance.block,
      'gridfins': instance.gridfins,
      'legs': instance.legs,
      'reused': instance.reused,
      'land_success': instance.landSuccess,
      'landing_intent': instance.landingIntent,
      'landing_type': instance.landingType,
      'landing_vehicle': instance.landingVehicle,
    };

GraphQLLaunchSecondStage _$GraphQLLaunchSecondStageFromJson(
        Map<String, dynamic> json) =>
    GraphQLLaunchSecondStage(
      block: (json['block'] as num?)?.toInt(),
      payloads: (json['payloads'] as List<dynamic>)
          .map((e) => GraphQLLaunchPayload.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GraphQLLaunchSecondStageToJson(
        GraphQLLaunchSecondStage instance) =>
    <String, dynamic>{
      'block': instance.block,
      'payloads': instance.payloads,
    };

GraphQLLaunchPayload _$GraphQLLaunchPayloadFromJson(
        Map<String, dynamic> json) =>
    GraphQLLaunchPayload(
      payloadId: json['payload_id'] as String,
      noradId: (json['norad_id'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      reused: json['reused'] as bool?,
      customers:
          (json['customers'] as List<dynamic>).map((e) => e as String).toList(),
      nationality: json['nationality'] as String,
      manufacturer: json['manufacturer'] as String,
      payloadType: json['payload_type'] as String,
      payloadMassKg: (json['payload_mass_kg'] as num?)?.toDouble(),
      payloadMassLbs: (json['payload_mass_lbs'] as num?)?.toDouble(),
      orbit: json['orbit'] as String,
      orbitParams: json['orbit_params'] == null
          ? null
          : GraphQLOrbitParams.fromJson(
              json['orbit_params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GraphQLLaunchPayloadToJson(
        GraphQLLaunchPayload instance) =>
    <String, dynamic>{
      'payload_id': instance.payloadId,
      'norad_id': instance.noradId,
      'reused': instance.reused,
      'customers': instance.customers,
      'nationality': instance.nationality,
      'manufacturer': instance.manufacturer,
      'payload_type': instance.payloadType,
      'payload_mass_kg': instance.payloadMassKg,
      'payload_mass_lbs': instance.payloadMassLbs,
      'orbit': instance.orbit,
      'orbit_params': instance.orbitParams,
    };

GraphQLOrbitParams _$GraphQLOrbitParamsFromJson(Map<String, dynamic> json) =>
    GraphQLOrbitParams(
      referenceSystem: json['reference_system'] as String?,
      regime: json['regime'] as String?,
      longitude: (json['longitude'] as num?)?.toDouble(),
      semiMajorAxisKm: (json['semi_major_axis_km'] as num?)?.toDouble(),
      eccentricity: (json['eccentricity'] as num?)?.toDouble(),
      periapsisKm: (json['periapsis_km'] as num?)?.toDouble(),
      apoapsisKm: (json['apoapsis_km'] as num?)?.toDouble(),
      inclinationDeg: (json['inclination_deg'] as num?)?.toDouble(),
      periodMin: (json['period_min'] as num?)?.toDouble(),
      lifespanYears: (json['lifespan_years'] as num?)?.toInt(),
      epoch: json['epoch'] as String?,
      meanMotion: (json['mean_motion'] as num?)?.toDouble(),
      raan: (json['raan'] as num?)?.toDouble(),
      argOfPericenter: (json['arg_of_pericenter'] as num?)?.toDouble(),
      meanAnomaly: (json['mean_anomaly'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GraphQLOrbitParamsToJson(GraphQLOrbitParams instance) =>
    <String, dynamic>{
      'reference_system': instance.referenceSystem,
      'regime': instance.regime,
      'longitude': instance.longitude,
      'semi_major_axis_km': instance.semiMajorAxisKm,
      'eccentricity': instance.eccentricity,
      'periapsis_km': instance.periapsisKm,
      'apoapsis_km': instance.apoapsisKm,
      'inclination_deg': instance.inclinationDeg,
      'period_min': instance.periodMin,
      'lifespan_years': instance.lifespanYears,
      'epoch': instance.epoch,
      'mean_motion': instance.meanMotion,
      'raan': instance.raan,
      'arg_of_pericenter': instance.argOfPericenter,
      'mean_anomaly': instance.meanAnomaly,
    };

GraphQLFairings _$GraphQLFairingsFromJson(Map<String, dynamic> json) =>
    GraphQLFairings(
      reused: json['reused'] as bool?,
      recoveryAttempt: json['recovery_attempt'] as bool?,
      recovered: json['recovered'] as bool?,
      ship: json['ship'] as String?,
    );

Map<String, dynamic> _$GraphQLFairingsToJson(GraphQLFairings instance) =>
    <String, dynamic>{
      'reused': instance.reused,
      'recovery_attempt': instance.recoveryAttempt,
      'recovered': instance.recovered,
      'ship': instance.ship,
    };

GraphQLShip _$GraphQLShipFromJson(Map<String, dynamic> json) => GraphQLShip(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      active: json['active'] as bool,
      imo: (json['imo'] as num?)?.toInt(),
      mmsi: (json['mmsi'] as num?)?.toInt(),
      abs: (json['abs'] as num?)?.toInt(),
      shipClass: (json['class'] as num?)?.toInt(),
      massKg: (json['mass_kg'] as num?)?.toInt(),
      massLbs: (json['mass_lbs'] as num?)?.toInt(),
      yearBuilt: (json['year_built'] as num?)?.toInt(),
      homePort: json['home_port'] as String?,
      status: json['status'] as String?,
      speedKn: (json['speed_kn'] as num?)?.toDouble(),
      courseDeg: (json['course_deg'] as num?)?.toDouble(),
      position: json['position'] == null
          ? null
          : GraphQLPosition.fromJson(json['position'] as Map<String, dynamic>),
      successfulLandings: (json['successful_landings'] as num?)?.toInt(),
      attemptedLandings: (json['attempted_landings'] as num?)?.toInt(),
      missions: (json['missions'] as List<dynamic>?)
          ?.map((e) => GraphQLMission.fromJson(e as Map<String, dynamic>))
          .toList(),
      url: json['url'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$GraphQLShipToJson(GraphQLShip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'roles': instance.roles,
      'active': instance.active,
      'imo': instance.imo,
      'mmsi': instance.mmsi,
      'abs': instance.abs,
      'class': instance.shipClass,
      'mass_kg': instance.massKg,
      'mass_lbs': instance.massLbs,
      'year_built': instance.yearBuilt,
      'home_port': instance.homePort,
      'status': instance.status,
      'speed_kn': instance.speedKn,
      'course_deg': instance.courseDeg,
      'position': instance.position,
      'successful_landings': instance.successfulLandings,
      'attempted_landings': instance.attemptedLandings,
      'missions': instance.missions,
      'url': instance.url,
      'image': instance.image,
    };

GraphQLPosition _$GraphQLPositionFromJson(Map<String, dynamic> json) =>
    GraphQLPosition(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GraphQLPositionToJson(GraphQLPosition instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

GraphQLMission _$GraphQLMissionFromJson(Map<String, dynamic> json) =>
    GraphQLMission(
      name: json['name'] as String,
      flight: (json['flight'] as num).toInt(),
    );

Map<String, dynamic> _$GraphQLMissionToJson(GraphQLMission instance) =>
    <String, dynamic>{
      'name': instance.name,
      'flight': instance.flight,
    };
