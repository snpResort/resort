import 'package:hive_flutter/adapters.dart';
import 'package:resort/home_page/model/date_book.dart';
import 'package:resort/home_page/model/rate.dart';

class Room {
  late String id;
  late String ten;
  late String moTa;
  late double gia;
  late int soNgLon;
  late int soTreEm;
  late int soLuongPhong;
  late List<RoomInfo> rooms;
  late List<String> images;
  late List<Rate> rates;
  late List<String> infos;
  late List<DateBook> ngayDaDat;
  Room();
}

class RoomInfo {
  late int id;
  late String tenPhong;
}
