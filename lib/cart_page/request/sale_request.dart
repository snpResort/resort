import 'dart:convert';

import 'package:http/http.dart';
import 'package:resort/constant/app_string.dart';

Future<double> getSale({required String id}) async {
  final String path = '/sale/getSale?id=$id';

  Response response = await get(
    Uri.parse('$kUrlServer$path'),
  );

  try {
    if (response.statusCode == 200) {
      double result = jsonDecode(response.body)['KhuyenMai'];
      return result;
    }
  } catch (e) {
    print('---------------$e');
  }
  return 0;
}
