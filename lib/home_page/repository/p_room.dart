import 'package:flutter/material.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';
import 'package:resort/home_page/model/room.dart';

class PRoom extends ChangeNotifier {
  Room? room;
  List<Room>? rooms;

  void setRoom(Room room) {
    this.room = room;

    notifyListeners();
  }

  void setRooms(List<Room> rooms) {
    this.rooms = rooms;

    notifyListeners();
  }
}
