import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/curren_user/domain/entities/user_org.dart';

part 'user_org_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class UserOrgModel extends HiveObject {
  @HiveField(0)
  String orgId;
  @HiveField(1)
  String role;
  UserOrgModel({required this.orgId, required this.role});
  factory UserOrgModel.fromJson(Map<String, dynamic> json) =>
      _$UserOrgModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserOrgModelToJson(this);

  factory UserOrgModel.fromEntity(UserOrg userOrg) {
    return UserOrgModel(orgId: userOrg.orgId, role: userOrg.role);
  }
}
