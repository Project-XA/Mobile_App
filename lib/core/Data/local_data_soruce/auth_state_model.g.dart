// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthStateModelAdapter extends TypeAdapter<AuthStateModel> {
  @override
  final int typeId = 3;

  @override
  AuthStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthStateModel(
      hasCompletedOCR: fields[0] as bool,
      hasRegistered: fields[1] as bool,
      isLoggedIn: fields[2] as bool,
      userRole: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthStateModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hasCompletedOCR)
      ..writeByte(1)
      ..write(obj.hasRegistered)
      ..writeByte(2)
      ..write(obj.isLoggedIn)
      ..writeByte(3)
      ..write(obj.userRole);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
