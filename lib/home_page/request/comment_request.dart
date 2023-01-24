import 'dart:convert';

import 'package:http/http.dart';
import 'package:resort/constant/app_string.dart';

class CommentResponse {
  bool? hasError;
  bool? hasData;
  String? message;
}

Future<CommentResponse> comment({required String user_id, required String room_id, required String comment, required double rate}) async {
  final String path = '/room/comment';
  CommentResponse result = CommentResponse();

  Map<String, String> headers = {"Content-type": "application/json"};
  final jsonData = {
    "user_id": user_id,
    "room_id": room_id,
    "comment": comment,
    "rate": rate,
    "create_at": DateTime.now().toLocal().toString().split('.')[0]
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
        ..hasData = true;
    }
    return result
        ..hasError = true
        ..hasData = false
        ..message = 'Đã xảy ra lỗi!\nVui lòng kiểm tra lại';
  } catch (e) {
    return result
      ..hasError = true
      ..hasData = false
      ..message = e.toString();
  }
}