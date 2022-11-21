import 'package:hive_flutter/hive_flutter.dart';
import 'package:resort/auth/models/user.dart';

class DBUser {
  static String dirName = 'myPlaylist';
  static Box<User> _getBox() => Hive.box<User>(dirName);

  static void saveUser(User user) {
    _getBox().put('user', user);
  }

  static void refeshToken(User user) {
    // Todo: refesh token
    _getBox().put('user', user);
  }

  static void deleteUser() {
    _getBox().deleteAt(0);
  }

  static bool hasLogin() => _getBox().length != 0;

  static String getAccessToken() => _getBox().get('user')!.accessToken ?? '';
}
