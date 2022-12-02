// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberAdapter extends TypeAdapter<Member> {
  @override
  final int typeId = 1;

  @override
  Member read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Member(
      loaiThanhVien: fields[0] as String,
      ngayTao: fields[1] as DateTime,
      ngayHetHan: fields[2] as int,
      khuyenMai: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Member obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.loaiThanhVien)
      ..writeByte(1)
      ..write(obj.ngayTao)
      ..writeByte(2)
      ..write(obj.ngayHetHan)
      ..writeByte(3)
      ..write(obj.khuyenMai);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
