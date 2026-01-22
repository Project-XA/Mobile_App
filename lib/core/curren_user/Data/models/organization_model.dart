import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/curren_user/domain/entities/organization.dart';
part 'organization_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class OrganizationModel extends HiveObject {
  @HiveField(0)
  String orgId;
  @HiveField(1)
  String orgName;

  OrganizationModel({required this.orgId, required this.orgName});
  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);

  factory OrganizationModel.fromEntity(Organization organization) {
    return OrganizationModel(
      orgId: organization.orgId,
      orgName: organization.orgName,
    );
  }
  Organization toEntity() {
    return Organization(orgId: orgId, orgName: orgName);
  }
}
