// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

import 'package:resort/auth/models/member.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String password;

  @HiveField(2)
  late String hoTen;

  @HiveField(3)
  late DateTime ngaySinh;

  @HiveField(4)
  late String canCuoc;

  @HiveField(5)
  late String sdt;

  @HiveField(6)
  late String email;

  @HiveField(7)
  late String gioiTinh;

  @HiveField(8)
  late String diaChi;

  @HiveField(9)
  late String avt;

  @HiveField(10)
  late String idTK;

  @HiveField(11)
  late int diemTichLuy;

  @HiveField(12)
  late Member member;

  User.info({
    required this.hoTen,
    required this.avt,
    required this.idTK,
  });

  User({
    required this.username,
    required this.password,
    required this.hoTen,
    required this.ngaySinh,
    required this.canCuoc,
    required this.sdt,
    required this.email,
    required this.gioiTinh,
    required this.diaChi,
    required this.avt,
    required this.idTK,
    required this.diemTichLuy,
    required this.member,
  });

  User.login({
    required this.username,
    required this.password,
  });

  @override
  String toString() {
    return 'User(username: $username, password: $password, hoTen: $hoTen, ngaySinh: $ngaySinh, canCuoc: $canCuoc, sdt: $sdt, email: $email, gioiTinh: $gioiTinh, diaChi: $diaChi, avt: $avt, idTK: $idTK, diemTichLuy: $diemTichLuy, member: $member)';
  }
}
