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

  Member({
    required this.loaiThanhVien,
    required this.ngayTao,
    required this.ngayHetHan,
    required this.khuyenMai,
  });
}
