import 'package:flutter/material.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';
import 'package:resort/home_page/model/count_info_room.dart';
import 'package:resort/home_page/model/date_book.dart';
import 'package:resort/home_page/model/info_book.dart';
import 'package:resort/home_page/model/room.dart';

class PRoom extends ChangeNotifier {
  Room? room;
  List<Room>? rooms;
  DateBook? dateBook;
  CountInfoRoom? countInfo;
  List<InfoBook> infoBook = [];

  void setInfoBook(InfoBook infoBook) {
    this.infoBook.add(infoBook);

    notifyListeners();
  }

  bool deleteAllInfoBook() {
    this.infoBook.clear();

    notifyListeners();

    return true;
  }

  bool deleteInfoBook_p(String tenPhong) {
    final infoBook =
        this.infoBook.firstWhere((element) => element.tenLP == tenPhong);
    this.infoBook.remove(infoBook);

    notifyListeners();

    return true;
  }

  bool deleteInfoBook(InfoBook infoBook) {
    this.infoBook.remove(infoBook);

    notifyListeners();

    return true;
  }

  void setCountInfo(CountInfoRoom countInfo) {
    this.countInfo = countInfo;

    notifyListeners();
  }

  void setDateBook(DateBook dateBook) {
    this.dateBook = dateBook;

    notifyListeners();
  }

  void setRoom(Room room) {
    this.room = room;

    notifyListeners();
  }

  void setRooms(List<Room> rooms) {
    this.rooms = rooms;

    notifyListeners();
  }
}
