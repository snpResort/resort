// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      username: fields[0] as String,
      password: fields[1] as String,
      hoTen: fields[2] as String,
      ngaySinh: fields[3] as DateTime,
      canCuoc: fields[4] as String,
      sdt: fields[5] as String,
      email: fields[6] as String,
      gioiTinh: fields[7] as String,
      diaChi: fields[8] as String,
      avt: fields[9] as String,
      idTK: fields[10] as String,
      diemTichLuy: fields[11] as int,
      member: fields[12] as Member,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.hoTen)
      ..writeByte(3)
      ..write(obj.ngaySinh)
      ..writeByte(4)
      ..write(obj.canCuoc)
      ..writeByte(5)
      ..write(obj.sdt)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.gioiTinh)
      ..writeByte(8)
      ..write(obj.diaChi)
      ..writeByte(9)
      ..write(obj.avt)
      ..writeByte(10)
      ..write(obj.idTK)
      ..writeByte(11)
      ..write(obj.diemTichLuy)
      ..writeByte(12)
      ..write(obj.member);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
