import 'package:json_annotation/json_annotation.dart';

part 'save_attendance_response.g.dart';

@JsonSerializable()
class SaveAttendanceResponse {
  final bool success;
  final String message;
  final SaveAttendanceData? data;
  final List<String> errors;

  SaveAttendanceResponse({
    required this.success,
    required this.message,
    this.data,
    required this.errors,
  });

  factory SaveAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$SaveAttendanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SaveAttendanceResponseToJson(this);
}

@JsonSerializable()
class SaveAttendanceData {
  final int savedCount;
  final int sessionId;

  SaveAttendanceData({
    required this.savedCount,
    required this.sessionId,
  });

  factory SaveAttendanceData.fromJson(Map<String, dynamic> json) =>
      _$SaveAttendanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$SaveAttendanceDataToJson(this);
}