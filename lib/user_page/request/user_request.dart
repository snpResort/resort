import 'dart:convert';

import 'package:http/http.dart';
import 'package:resort/constant/app_string.dart';

Future<String> updateAvatar({required String base64, required String userID}) async {
  final String path = '/user/updateavt';

  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"userId": "$userID", "image": "$base64"}';

  print(json);

  Response response = await post(
    Uri.parse('$kUrlServer$path'),    
    headers: headers,
    body: json
  );

  try {
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('-------- result: $result');
      return result['image'];
    }
  } catch (e) {
    print('---------------$e');
  }
  return '';
}