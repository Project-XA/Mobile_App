// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      nationalId: fields[0] as String,
      firstNameAr: fields[1] as String,
      lastNameAr: fields[2] as String,
      address: fields[3] as String?,
      birthDate: fields[4] as String?,
      email: fields[5] as String?,
      firstNameEn: fields[6] as String?,
      lastNameEn: fields[7] as String?,
      organizations: (fields[8] as List?)?.cast<UserOrgModel>(),
      profileImage: fields[9] as String?,
      idCardImage: fields[10] as String?,
      loginToken: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.nationalId)
      ..writeByte(1)
      ..write(obj.firstNameAr)
      ..writeByte(2)
      ..write(obj.lastNameAr)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.birthDate)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.firstNameEn)
      ..writeByte(7)
      ..write(obj.lastNameEn)
      ..writeByte(8)
      ..write(obj.organizations)
      ..writeByte(9)
      ..write(obj.profileImage)
      ..writeByte(10)
      ..write(obj.idCardImage)
      ..writeByte(11)
      ..write(obj.loginToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      nationalId: json['nationalId'] as String,
      firstNameAr: json['firstNameAr'] as String,
      lastNameAr: json['lastNameAr'] as String,
      address: json['address'] as String?,
      birthDate: json['birthDate'] as String?,
      email: json['email'] as String?,
      firstNameEn: json['firstNameEn'] as String?,
      lastNameEn: json['lastNameEn'] as String?,
      organizations: (json['organizations'] as List<dynamic>?)
          ?.map((e) => UserOrgModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      profileImage: json['profileImage'] as String?,
      idCardImage: json['idCardImage'] as String?,
      loginToken: json['loginToken'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'nationalId': instance.nationalId,
      'firstNameAr': instance.firstNameAr,
      'lastNameAr': instance.lastNameAr,
      'address': instance.address,
      'birthDate': instance.birthDate,
      'email': instance.email,
      'firstNameEn': instance.firstNameEn,
      'lastNameEn': instance.lastNameEn,
      'organizations': instance.organizations,
      'profileImage': instance.profileImage,
      'idCardImage': instance.idCardImage,
      'loginToken': instance.loginToken,
    };
