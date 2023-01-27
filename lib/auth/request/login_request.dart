import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/member.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/constant/app_string.dart';

Future<User?> loginRequest({
  required String username,
  required String password,
}) async {
  final String path = '/auth/login';

  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"username": "$username", "password": "$password"}';

  Response response = await post(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
    body: json,
  );

  try {
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      final info = result['ThongTinCaNhan'];
      final member = result['ThanhVien'];
      User user = User(
        username: username,
        password: password,
        hoTen: info['HoTen'].toString(),
        ngaySinh: DateTime.parse(info['NgaySinh']),
        canCuoc: info['CanCuoc'].toString(),
        sdt: info['Sdt'].toString(),
        email: info['Email'],
        gioiTinh: info['GioiTinh'],
        diaChi: info['DiaChi'],
        avt: info['AnhDaiDien'] ?? '',
        idTK: info['Id_tk'],
        diemTichLuy: result['DiemTichLuy'],
        member: Member(
          id: member['id'],
          loaiThanhVien: member['TenLoai'],
          ngayTao: DateTime.parse(member['NgayTao']),
          ngayHetHan: member['NgayHetHan'],
          khuyenMai: member['KhuyenMai'],
        ),
      );

      return user;
    }
  } catch (e) {
    return null;
  }
}
