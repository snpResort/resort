Future<List<dynamic>> updateAvatar({required String base64}) async {
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