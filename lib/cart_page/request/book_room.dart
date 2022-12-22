import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:resort/constant/app_string.dart';

Future<bool> bookedRequest(
    {required String username,
    required int soLuongNguoiTH,
    required int soLuongTreEm,
    required double gia,
    required DateTime ngayDat,
    required DateTime ngayTra,
    required List<int> idPhong}) async {
  final String path = '/room/bookRoom';

  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Map<String, String> headers = {"Content-type": "application/json"};
  String json =
      '{"username": "$username", "soLuongNguoiTH": "$soLuongNguoiTH", "soLuongTreEm": "$soLuongTreEm", "gia": "$gia", "ngayDat": "${_dateFormat.format(ngayDat)}", "ngayTra": "${_dateFormat.format(ngayTra)}", "idPhong": "$idPhong"}';

  Response response = await post(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
    body: json,
  );

  try {
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      return true;
    }
  } catch (e) {}
  return false;
}
