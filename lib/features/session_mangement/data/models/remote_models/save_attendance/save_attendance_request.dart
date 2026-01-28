
import 'package:json_annotation/json_annotation.dart';

part 'save_attendance_request.g.dart';

@JsonSerializable()
class SaveAttendanceRequest {
  final int sessionId;
  final List<AttendanceLogItem> attendanceLogs;

  SaveAttendanceRequest({
    required this.sessionId,
    required this.attendanceLogs,
  });

  factory SaveAttendanceRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveAttendanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SaveAttendanceRequestToJson(this);
}

@JsonSerializable()
class AttendanceLogItem {
  final String userId;
  final String timeStamp;
  @JsonKey(unknownEnumValue: AttendanceResult.absent)
  final AttendanceResult result;
  final String? proofSignature;
  final int? verificationId;

  AttendanceLogItem({
    required this.userId,
    required this.timeStamp,
    required this.result,
    this.proofSignature,
    this.verificationId,
  });

  factory AttendanceLogItem.fromJson(Map<String, dynamic> json) =>
      _$AttendanceLogItemFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceLogItemToJson(this);
}

@JsonEnum()
enum AttendanceResult {
  @JsonValue('Present')
  present,
  @JsonValue('Absent')
  absent,
  @JsonValue('Late')
  late,
  @JsonValue('Excused')
  excused,
}