import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/member.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/constant/app_string.dart';

Future<String?> SendVerifyCode({required String username}) async {
  final String path = '/auth/sendverifycode';

  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{ "username": "$username" }';

  Response response = await post(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
    body: json,
  );

  try {
    if (response.statusCode == 200) {
      var token = jsonDecode(response.body)['message'];
      return token;
    }
  } catch (e) {
    return null;
  }
}

Future<Map<String, dynamic>?> VerifyCode({
  required String token,
  required String code,
}) async {
  final String path = '/auth/verifycode';

  Map<String, String> headers = {
    "Content-type": "application/json",
    'Authorization': token,
  };
  String json = '{ "code": "$code" }';

  Response response = await post(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
    body: json,
  );

  try {
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    }
  } catch (e) {
    return null;
  }
}

Future<RegisterResponse> RegisterRequest({required User user}) async {
  final String path = '/auth/register';
  RegisterResponse result = RegisterResponse();

  Map<String, String> headers = {"Content-type": "application/json"};
  // String json =
  //     '{"username": "${user.username}","password": "${user.password}","hoTen": "${user.hoTen}","ngaySinh": "${DateFormat('yyyy-MM-dd').format(user.ngaySinh)}","cccd": "${user.canCuoc}","email": "${user.email}","sdt": "${user.sdt.replaceAll(' ', '')}","diaChi": "${user.diaChi}"}';

  final jsonData = {
    "username": "${user.username}",
    "password": "${user.password}",
    "hoTen": "${user.hoTen}",
    "ngaySinh": "${DateFormat('yyyy-MM-dd').format(user.ngaySinh)}",
    "cccd": "${user.canCuoc}",
    "email": "${user.email}",
    "gioiTinh":"${user.gioiTinh.toUpperCase()}",
    "sdt": "${user.sdt.replaceAll(' ', '')}",
    "diaChi": "${user.diaChi}"
  };

  print('------------ json data register: $jsonData');

  Response response = await post(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
    body: jsonEncode(jsonData),
  );

  try {
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result
        ..hasData = true
        ..hasError = false
        ..message = body['Message'];
    }
    return result
      ..hasData = false
      ..hasError = true
      ..message = body['Message'];
  } catch (e) {
    return result
      ..hasData = false
      ..hasError = true
      .. message = e.toString();
  }
}

Future<RegisterResponse> EditInfoUser({required User user}) async {
  final String path = '/auth/editInfoUser';
  RegisterResponse result = RegisterResponse();

  Map<String, String> headers = {"Content-type": "application/json"};
  // String json =
  //     '{"username": "${user.username}","password": "${user.password}","hoTen": "${user.hoTen}","ngaySinh": "${DateFormat('yyyy-MM-dd').format(user.ngaySinh)}","cccd": "${user.canCuoc}","email": "${user.email}","sdt": "${user.sdt.replaceAll(' ', '')}","diaChi": "${user.diaChi}"}';

  final jsonData = {
    "username": "${user.username}",
    "hoTen": "${user.hoTen}",
    "ngaySinh": "${DateFormat('yyyy-MM-dd').format(user.ngaySinh)}",
    "cccd": "${user.canCuoc}",
    "gioiTinh":"${user.gioiTinh.toUpperCase()}",
    "sdt": "${user.sdt.replaceAll(' ', '')}",
    "diaChi": "${user.diaChi}"
  };

  print('------------ json data register: $jsonData');

  Response response = await post(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
    body: jsonEncode(jsonData),
  );

  try {
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result
        ..hasData = true
        ..hasError = false
        ..message = body['Message'];
    }
    return result
      ..hasData = false
      ..hasError = true
      ..message = body['Message'];
  } catch (e) {
    return result
      ..hasData = false
      ..hasError = true
      .. message = e.toString();
  }
}

class RegisterResponse {
  bool? hasData;
  bool? hasError;
  String? message;
}


Future<bool> CheckUsername({required String username}) async {
  final String path = '/auth/checkUsername?username=$username';

  Response response = await get(
    Uri.parse('$kUrlServer$path'),
  );

  try {
    if (response.statusCode == 200) {
      String result = jsonDecode(response.body)['status'];
      return result.contains('OK');
    }
  } catch (e) {
    print('---------------$e');
  }
  return false;
}
