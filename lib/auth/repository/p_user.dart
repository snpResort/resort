import 'package:flutter/material.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';

class PUser extends ChangeNotifier {
  User? user;
  bool isLogin = false;
  String? token;

  void setToken(token) {
    this.token = token;
    notifyListeners();
  }

  void setupUser(User user) {
    isLogin = false;
    this.user = user;

    notifyListeners();
  }

  void login(User user) {
    isLogin = true;
    this.user = user;

    DBUser.saveUser(user);
    notifyListeners();
  }

  void signout() {
    user = null;
    isLogin = false;

    DBUser.deleteUser();
    notifyListeners();
  }

  void clear() {
    user = null;
    isLogin = false;
    token = null;

    notifyListeners();
  }
}
