// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_attendance_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveAttendanceRequest _$SaveAttendanceRequestFromJson(
        Map<String, dynamic> json) =>
    SaveAttendanceRequest(
      sessionId: (json['sessionId'] as num).toInt(),
      attendanceLogs: (json['attendanceLogs'] as List<dynamic>)
          .map((e) => AttendanceLogItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SaveAttendanceRequestToJson(
        SaveAttendanceRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'attendanceLogs': instance.attendanceLogs,
    };

AttendanceLogItem _$AttendanceLogItemFromJson(Map<String, dynamic> json) =>
    AttendanceLogItem(
      userId: json['userId'] as String,
      timeStamp: json['timeStamp'] as String,
      result: $enumDecode(_$AttendanceResultEnumMap, json['result'],
          unknownValue: AttendanceResult.absent),
      proofSignature: json['proofSignature'] as String?,
      verificationId: (json['verificationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AttendanceLogItemToJson(AttendanceLogItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timeStamp': instance.timeStamp,
      'result': _$AttendanceResultEnumMap[instance.result]!,
      'proofSignature': instance.proofSignature,
      'verificationId': instance.verificationId,
    };

const _$AttendanceResultEnumMap = {
  AttendanceResult.present: 'Present',
  AttendanceResult.absent: 'Absent',
  AttendanceResult.late: 'Late',
  AttendanceResult.excused: 'Excused',
};
