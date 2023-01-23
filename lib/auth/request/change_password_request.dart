import 'dart:convert';

import 'package:http/http.dart';
import 'package:resort/constant/app_string.dart';

class ChangePasswordResponse {
  bool? hasError;
  bool? hasData;
  String? message;
}

Future<ChangePasswordResponse> changePassword({required String username, required String password}) async {
  final String path = '/auth/changePassword';
  ChangePasswordResponse result = ChangePasswordResponse();

  Map<String, String> headers = {"Content-type": "application/json"};
  final jsonData = {
    "username": username,
    "password": password
  };

  print('run $path');
  print(jsonData);

  Response response = await post(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
    body: jsonEncode(jsonData),
  );

  try {
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result
        ..hasError = false
        ..hasData = true
        ..message = body['Message'] ?? '';
    }
    return result
        ..hasError = true
        ..hasData = false
        ..message = body['Message'] ?? '';
  } catch (e) {
    return result
      ..hasError = true
      ..hasData = false
      ..message = e.toString();
  }
}