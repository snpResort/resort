import 'package:flutter/material.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';

class PUser extends ChangeNotifier {
  User? user;
  bool isLogin = false;

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
}
