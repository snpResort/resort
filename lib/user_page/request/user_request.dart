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

Future<List> saleMember() async {
  final String path = '/user/getSaleMember';

  Map<String, String> headers = {"Content-type": "application/json"};

  Response response = await get(
    Uri.parse('$kUrlServer$path'),    
    headers: headers,
  );

  try {
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List;
      return result;
    }
  } catch (e) {
    print('---------------$e');
  }
  return [];
}

Future<String> updateMember({ required String user_id, required String id_level }) async {
  final String path = '/user/updateMember';

  Map<String, String> headers = {"Content-type": "application/json"};

  final jsonData = {
    "user_id": user_id,
    "id_level": id_level
  };

  Response response = await post(
    Uri.parse('$kUrlServer$path'),    
    headers: headers,
    body: jsonEncode(jsonData)
  );

  try {
    if (response.statusCode == 200) {
      return 'Nâng cấp thành công';
    }
  } catch (e) {
    print('---------------$e');
  }
  return 'Error';
}