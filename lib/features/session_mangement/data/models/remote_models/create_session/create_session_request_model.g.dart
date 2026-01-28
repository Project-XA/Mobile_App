// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSessionRequestModel _$CreateSessionRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateSessionRequestModel(
      organizationId: (json['organizationId'] as num).toInt(),
      sessionName: json['sessionName'] as String,
      createdBy: json['createdBy'] as String,
      hallName: json['hallName'] as String,
      connectionType: json['connectionType'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      allowedRadius: (json['allowedRadius'] as num).toDouble(),
      networkSSID: json['networkSSID'] as String,
      networkBSSID: json['networkBSSID'] as String,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
      hallId: (json['hallId'] as num).toInt(),
    );

Map<String, dynamic> _$CreateSessionRequestModelToJson(
        CreateSessionRequestModel instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'sessionName': instance.sessionName,
      'createdBy': instance.createdBy,
      'hallName': instance.hallName,
      'connectionType': instance.connectionType,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'allowedRadius': instance.allowedRadius,
      'networkSSID': instance.networkSSID,
      'networkBSSID': instance.networkBSSID,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
      'hallId': instance.hallId,
    };
