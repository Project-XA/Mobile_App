// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_attendance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveAttendanceResponse _$SaveAttendanceResponseFromJson(
        Map<String, dynamic> json) =>
    SaveAttendanceResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : SaveAttendanceData.fromJson(json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SaveAttendanceResponseToJson(
        SaveAttendanceResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

SaveAttendanceData _$SaveAttendanceDataFromJson(Map<String, dynamic> json) =>
    SaveAttendanceData(
      savedCount: (json['savedCount'] as num).toInt(),
      sessionId: (json['sessionId'] as num).toInt(),
    );

Map<String, dynamic> _$SaveAttendanceDataToJson(SaveAttendanceData instance) =>
    <String, dynamic>{
      'savedCount': instance.savedCount,
      'sessionId': instance.sessionId,
    };
