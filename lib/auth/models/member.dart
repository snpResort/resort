// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

part 'member.g.dart';

@HiveType(typeId: 1)
class Member {
  @HiveField(0)
  late String loaiThanhVien;

  @HiveField(1)
  late DateTime ngayTao;

  @HiveField(2)
  late int ngayHetHan;

  @HiveField(3)
  late double khuyenMai;

  @HiveField(4)
  late int id;

  Member({
    required this.loaiThanhVien,
    required this.ngayTao,
    required this.ngayHetHan,
    required this.khuyenMai,
    required this.id
  });


  @override
  String toString() {
    return 'Member(loaiThanhVien: $loaiThanhVien, ngayTao: $ngayTao, ngayHetHan: $ngayHetHan, khuyenMai: $khuyenMai, id: $id)';
  }
}
