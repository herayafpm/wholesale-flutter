// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      username: fields[1] as String,
      nama: fields[2] as String,
      alamat: fields[4] as String,
      email: fields[3] as String,
      no_telp: fields[5] as String,
      role_id: fields[6] as int,
      role_nama: fields[7] as String,
      token: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.nama)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.alamat)
      ..writeByte(5)
      ..write(obj.no_telp)
      ..writeByte(6)
      ..write(obj.role_id)
      ..writeByte(7)
      ..write(obj.role_nama)
      ..writeByte(8)
      ..write(obj.token);
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
