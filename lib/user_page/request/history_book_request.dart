import 'dart:convert';

import 'package:http/http.dart';
import 'package:resort/constant/app_string.dart';

Future<List<dynamic>> historyBookedRoom({required String userID}) async {
  final String path = '/room/getHistoryBooked?userID=$userID';

  Response response = await get(
    Uri.parse('$kUrlServer$path'),
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
