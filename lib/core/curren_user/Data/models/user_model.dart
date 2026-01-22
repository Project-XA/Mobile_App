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

  UserModel({
    required this.nationalId,
    required this.firstNameAr,
    required this.lastNameAr,
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
    );
  }

  User toEntity() {
    return User(
      nationalId: nationalId,
      firstNameAr: firstNameAr,
      lastNameAr: lastNameAr,
      address: address,
      birthDate: birthDate,
      email: email,
      firstNameEn: firstNameEn,
      lastNameEn: lastNameEn,
      organizations: organizations
          ?.map((orgModel) => UserOrg(
                orgId: orgModel.orgId,
                role: orgModel.role,
              ))
          .toList(),
      profileImage: profileImage,
      idCardImage: idCardImage,
      loginToken: loginToken,
    );
  }

  // ⭐ Helper method to clear only auth data
  UserModel copyWithClearedAuth() {
    return UserModel(
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
      loginToken: null, // Clear token only
    );
  }
}