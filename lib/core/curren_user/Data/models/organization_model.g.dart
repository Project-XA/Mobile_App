// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationModelAdapter extends TypeAdapter<OrganizationModel> {
  @override
  final int typeId = 2;

  @override
  OrganizationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationModel(
      orgId: fields[0] as String,
      orgName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.orgId)
      ..writeByte(1)
      ..write(obj.orgName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) =>
    OrganizationModel(
      orgId: json['orgId'] as String,
      orgName: json['orgName'] as String,
    );

Map<String, dynamic> _$OrganizationModelToJson(OrganizationModel instance) =>
    <String, dynamic>{
      'orgId': instance.orgId,
      'orgName': instance.orgName,
    };
