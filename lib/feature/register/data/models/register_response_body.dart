import 'package:json_annotation/json_annotation.dart';

part 'register_response_body.g.dart';

@JsonSerializable()
class RegisterResponseBody {
  final UserResponse userResponse;
  final String loginToken;

  RegisterResponseBody({
    required this.userResponse,
    required this.loginToken,
  });

  factory RegisterResponseBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseBodyToJson(this);
}

@JsonSerializable()
class UserResponse {
  final String id;
  final String fullName;
  final String userName;
  final String email;
  final String? phoneNumber;
  final String role;
  final String createdAt;
  final String updatedAt;

  UserResponse({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    this.phoneNumber,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}