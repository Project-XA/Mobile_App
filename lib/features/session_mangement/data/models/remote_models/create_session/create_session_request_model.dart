import 'package:json_annotation/json_annotation.dart';
part 'create_session_request_model.g.dart';

@JsonSerializable()
class CreateSessionRequestModel {
  final int organizationId;
  final String sessionName;
  final String createdBy;
  final String hallName;
  final String connectionType;
  final double longitude;
  final double latitude;
  final double allowedRadius;
  final String networkSSID;
  final String networkBSSID;
  final String startAt;
  final String endAt;
  final int hallId;

  CreateSessionRequestModel({
    required this.organizationId,
    required this.sessionName,
    required this.createdBy,
    required this.hallName,
    required this.connectionType,
    required this.longitude,
    required this.latitude,
    required this.allowedRadius,
    required this.networkSSID,
    required this.networkBSSID,
    required this.startAt,
    required this.endAt,
    required this.hallId,
  });

  factory CreateSessionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSessionRequestModelToJson(this);
}
