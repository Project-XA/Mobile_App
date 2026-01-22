// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_org_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserOrgModelAdapter extends TypeAdapter<UserOrgModel> {
  @override
  final int typeId = 1;

  @override
  UserOrgModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserOrgModel(
      orgId: fields[0] as String,
      role: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserOrgModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.orgId)
      ..writeByte(1)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserOrgModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOrgModel _$UserOrgModelFromJson(Map<String, dynamic> json) => UserOrgModel(
      orgId: json['orgId'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserOrgModelToJson(UserOrgModel instance) =>
    <String, dynamic>{
      'orgId': instance.orgId,
      'role': instance.role,
    };
