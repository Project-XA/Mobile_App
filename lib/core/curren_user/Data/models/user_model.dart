// data/models/user_model.dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_org_model.dart';
import 'package:mobile_app/core/curren_user/domain/entities/user.dart';
import 'package:mobile_app/core/curren_user/domain/entities/user_org.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String nationalId;

  @HiveField(1)
  String firstNameAr;

  @HiveField(2)
  String lastNameAr;

  @HiveField(3)
  String? address;

  @HiveField(4)
  String? birthDate;

  @HiveField(5)
  String? email;

  @HiveField(6)
  String? firstNameEn;

  @HiveField(7)
  String? lastNameEn;

  @HiveField(8)
  List<UserOrgModel>? organizations;

  @HiveField(9)
  String? profileImage;

  @HiveField(10)
  String? idCardImage;

  @HiveField(11)
  String? loginToken;
  @HiveField(12)
  String? id;
  @HiveField(13)
  String? username;

  UserModel({
    required this.nationalId,
    required this.firstNameAr,
    required this.lastNameAr,
    this.id,
    this.username,
    this.address,
    this.birthDate,
    this.email,
    this.firstNameEn,
    this.lastNameEn,
    this.organizations,
    this.profileImage,
    this.idCardImage,
    this.loginToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      nationalId: user.nationalId,
      firstNameAr: user.firstNameAr,
      lastNameAr: user.lastNameAr,
      address: user.address,
      birthDate: user.birthDate,
      email: user.email,
      firstNameEn: user.firstNameEn,
      lastNameEn: user.lastNameEn,
      organizations: user.organizations
          ?.map((org) => UserOrgModel.fromEntity(org))
          .toList(),
      profileImage: user.profileImage,
      idCardImage: user.idCardImage,
      loginToken: user.loginToken,
      username: user.username,
    );
  }

  User toEntity() {
    return User(
      id: id,
      nationalId: nationalId,
      firstNameAr: firstNameAr,
      lastNameAr: lastNameAr,
      address: address,
      birthDate: birthDate,
      email: email,
      firstNameEn: firstNameEn,
      lastNameEn: lastNameEn,
      organizations: organizations
          ?.map(
            (orgModel) => UserOrg(
              organizationId: orgModel.organizationId,
              role: orgModel.role,
              organizationName: orgModel.organizationName,
            ),
          )
          .toList(),
      profileImage: profileImage,
      idCardImage: idCardImage,
      loginToken: loginToken,
      username: username,
    );
  }

  UserModel copyWithClearedAuth() {
    return UserModel(
      id: id,
      nationalId: nationalId,
      firstNameAr: firstNameAr,
      lastNameAr: lastNameAr,
      address: address,
      birthDate: birthDate,
      email: email,
      firstNameEn: firstNameEn,
      lastNameEn: lastNameEn,
      organizations: organizations,
      profileImage: profileImage,
      idCardImage: idCardImage,
      loginToken: null, 
      username: username,
      // Clear token only
    );
  }
}
