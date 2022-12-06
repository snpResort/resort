import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/member.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/explore_page/model/service.dart';

Future<List<String>?> serviceImageRequest() async {
  final String path = '/service/getImagesServices';

  Map<String, String> headers = {"Content-type": "application/json"};

  Response response = await get(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
  );

  try {
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body)['Images'];
      final data = List<String>.from(result);
      return data;
    }
  } catch (e) {
    return [];
  }
}

Future<List<Service>?> serviceRequest() async {
  final String path = '/service/getServices';

  Map<String, String> headers = {"Content-type": "application/json"};

  Response response = await get(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
  );

  try {
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body) as List;
      final data = result.map((rs) {
        Service service = Service();
        return service
          ..id = rs['Id']
          ..images = List<String>.from(rs['Images'])
          ..moTa = rs['MoTa']
          ..tenDV = rs['TenDV'];
      }).toList();
      return data;
    }
  } catch (e) {
    return [];
  }
}
