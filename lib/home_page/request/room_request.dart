import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/model/date_book.dart';
import 'package:resort/home_page/model/rate.dart';
import 'package:resort/home_page/model/room.dart';

Future<List<Room>?> roomRequest() async {
  final String path = '/room/getRooms';

  Map<String, String> headers = {"Content-type": "application/json"};

  Response response = await get(
    Uri.parse('$kUrlServer$path'),
    headers: headers,
  );

  try {
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List<Room> rooms = [];
      for (var room in result) {
        Room r = Room();
        List<Rate> rates = [];
        List<DateBook> ngatDaDat = [];
        List<RoomInfo> roomInfo = [];

        for (var _room in room['DanhSachPhong']) {
          roomInfo.add(RoomInfo()
            ..id = _room['Id']
            ..tenPhong = _room['TenPhong']);
        }

        for (var rate in room['Rate']) {
          rates.add(Rate()
            ..ngTao = DateTime.parse(rate['NgayTao'])
            ..binhChon = rate['BinhChon']
            ..binhLuan = rate['BinhLuan']
            ..userInfo = User.info(
              hoTen: rate['user_info']['HoTen'],
              avt: '',
              idTK: rate['user_info']['Id_tk'],
            ));
        }

        for (var booked in room['NgayDaDat']) {
          ngatDaDat.add(DateBook()
            ..timeCheckin = DateTime.parse(booked['Checkin'])
            ..timeCheckout = DateTime.parse(booked['Checkout'])
            ..room = booked['Phong']);
        }

        r
          ..id = room['Id']
          ..ten = room['TenLoai']
          ..moTa = room['MoTa']
          ..gia = double.parse(room['Gia'].toString())
          ..soLuongPhong = room['SoLuongPhong']
          ..soNgLon = room['SoLuongNguoiLon']
          ..soTreEm = room['SoLuongTreEm']
          ..images =
              (room['Images'] as List).map((val) => val.toString()).toList()
          ..infos =
              (room['ThongTin'] as List).map((val) => val.toString()).toList()
          ..rates = rates
          ..ngayDaDat = ngatDaDat
          ..rooms = roomInfo;

        rooms.add(r);
      }

      return rooms;
    }
  } catch (e) {
    return null;
  }
}
