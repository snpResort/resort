import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/cart_page/screen/cart_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/model/count_info_room.dart';
import 'package:resort/home_page/model/date_book.dart';
import 'package:resort/home_page/model/info_book.dart';
import 'package:resort/home_page/model/room.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/home_page/screen/home_page.dart';
import 'package:resort/main.dart';
import 'package:resort/widgets/calendar_custom.dart';
import 'package:resort/widgets/gradient_mask.dart';
import 'package:resort/widgets/wrong_alert.dart';

class RoomInfoPage extends StatefulWidget {
  const RoomInfoPage({super.key});

  static String id = 'RoomInfoPage';

  @override
  State<RoomInfoPage> createState() => _RoomInfoPageState();
}

class _RoomInfoPageState extends State<RoomInfoPage> {
  final oCcyStar = NumberFormat("#.#");
  final oCcyMoney = NumberFormat("#,##0");
  DateTime _ngayDen = DateTime.now();
  DateTime _ngayDi = DateTime.now().add(Duration(days: 1));
  int _soLuongNguoi = 1;
  int _soLuongNguoiLon = 1;
  int _soLuongTreEm = 0;
  int _soLuongPhong = 1;
  bool _hasRoom = false;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    final roomInfo = Provider.of<PRoom>(context, listen: true).room;

    var _spdiver = Container(
      width: 2,
      decoration: BoxDecoration(
          color: Colors.black26, borderRadius: BorderRadius.circular(10)),
      height: _width / 16,
    );
    _title(title) => Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '$title',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: _width / 13,
            ),
          ),
        );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CarouselSlider(
              items: roomInfo!.images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: _width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(image),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: _width / 1.5,
                viewportFraction: 1.0,
                initialPage: 0,
                reverse: false,
                autoPlay: true,
                onPageChanged: (index, reason) {},
                scrollDirection: Axis.horizontal,
                pauseAutoPlayInFiniteScroll: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: _width / 1.8),
                  Container(
                    padding: EdgeInsets.all(15),
                    width: _width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${roomInfo.ten}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: _width / 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  RadiantGradientMask(
                                    child: Icon(
                                      CupertinoIcons.chat_bubble_text,
                                      size: _width / 16,
                                    ),
                                    gradient: [
                                      Colors.deepOrange,
                                      Colors.yellow,
                                      Colors.deepOrange,
                                      Colors.white,
                                    ],
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${sum_cmt(roomInfo.rates)}',
                                    style: TextStyle(
                                      fontSize: _width / 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                              // _spdiver,
                              Row(
                                children: [
                                  Text(
                                    '${oCcyStar.format(avg_rate(roomInfo.rates))}',
                                    style: TextStyle(
                                      fontSize: _width / 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  RadiantGradientMask(
                                    child: Icon(
                                      CupertinoIcons.star_fill,
                                      size: _width / 16,
                                    ),
                                    gradient: [
                                      Colors.deepOrange,
                                      Colors.orange.shade500,
                                      Colors.orange.shade200,
                                      Colors.yellow,
                                    ],
                                  ),
                                ],
                              ),
                              // _spdiver,
                              Row(
                                children: [
                                  RadiantGradientMask(
                                    child: Icon(
                                      CupertinoIcons.group,
                                      size: _width / 16,
                                    ),
                                    gradient: [
                                      Colors.deepOrange,
                                      Colors.yellow,
                                      Colors.deepOrange,
                                      Colors.white,
                                    ],
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${roomInfo.soNgLon + roomInfo.soTreEm}',
                                    style: TextStyle(
                                      fontSize: _width / 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        _title('Tổng quan'),
                        const SizedBox(height: 15),
                        Text(
                          '${roomInfo.moTa}',
                          style: TextStyle(
                            fontSize: _width / 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: roomInfo.infos.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final _roomInfo = roomInfo.infos[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                '${_roomInfo}',
                                style: TextStyle(
                                  fontSize: _width / 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        _hasRoom
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                width: _width / 1.1,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 2.5),
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        right: 5,
                                        left: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Giá trung bình một đêm',
                                                  style: TextStyle(
                                                    fontSize: _width / 26,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                                Text(
                                                  '${oCcyMoney.format(roomInfo.gia)} ₫',
                                                  style: TextStyle(
                                                    fontSize: _width / 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 2.5),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_outlined,
                                                  size: _width / 13,
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Ngày đến',
                                                      style: TextStyle(
                                                        fontSize: _width / 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${DateFormat('dd/MM/yyyy').format(_ngayDen)}',
                                                      style: TextStyle(
                                                        fontSize: _width / 20,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_outlined,
                                                  size: _width / 13,
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Ngày đi',
                                                      style: TextStyle(
                                                        fontSize: _width / 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${DateFormat('dd/MM/yyyy').format(_ngayDi)}',
                                                      style: TextStyle(
                                                        fontSize: _width / 20,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 2.5),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.person_3,
                                            size: _width / 13,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Khách Số lượng phòng',
                                                style: TextStyle(
                                                  fontSize: _width / 25,
                                                ),
                                              ),
                                              Text(
                                                '$_soLuongNguoi người, $_soLuongPhong phòng',
                                                style: TextStyle(
                                                  fontSize: _width / 20,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.black12,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Provider.of<PRoom>(context,
                                        //             listen: false)
                                        //         .setInfoBook(
                                        //       InfoBook()
                                        //         ..gia = roomInfo.gia *
                                        //             (_ngayDi.day -
                                        //                 _ngayDen.day +
                                        //                 1)
                                        //         ..ngayDat = Provider.of<PRoom>(
                                        //                 context,
                                        //                 listen: false)
                                        //             .dateBook!
                                        //         ..countInfoRoom =
                                        //             Provider.of<PRoom>(context,
                                        //                     listen: false)
                                        //                 .countInfo!,
                                        //     );
                                        //   },
                                        //   child: Container(
                                        //     alignment: Alignment.center,
                                        //     margin: EdgeInsets.symmetric(
                                        //         vertical: 2.5),
                                        //     child: Text(
                                        //       'Thêm vào giỏ\nhàng',
                                        //       textAlign: TextAlign.center,
                                        //       style: TextStyle(
                                        //           color: Colors.blue.shade300,
                                        //           fontSize: _width / 18),
                                        //     ),
                                        //   ),
                                        // ),
                                        // const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<PRoom>(
                                              context,
                                              listen: false,
                                            ).deleteAllInfoBook();

                                            // Todo: select room
                                            List<String> roomBooked = [];
                                            for (DateTime d = _ngayDen;
                                                d.compareTo(_ngayDi) <= 0;
                                                d = d.add(Duration(days: 1))) {
                                              roomBooked.addAll(roomInfo
                                                  .ngayDaDat
                                                  .where((info) =>
                                                      d.compareTo(info
                                                              .timeCheckin!) >=
                                                          0 &&
                                                      d.compareTo(info
                                                              .timeCheckout!) <=
                                                          0)
                                                  .map((e) => e.room)
                                                  .toSet()
                                                  .toList());
                                            }
                                            roomBooked =
                                                roomBooked.toSet().toList();

                                            // final listRoom = List.from(roomInfo.rooms);
                                            final phongConTrong = roomInfo.rooms
                                                .where((room) => !roomBooked
                                                    .contains(room.tenPhong))
                                                .toList();

                                            Provider.of<PRoom>(
                                              context,
                                              listen: false,
                                            ).setInfoBook(
                                              InfoBook()
                                                ..gia = roomInfo.gia *
                                                    (_ngayDi.day -
                                                        _ngayDen.day +
                                                        1)
                                                ..ngayDat = (DateBook()
                                                  ..timeCheckout = _ngayDi
                                                  ..timeCheckin = _ngayDen)
                                                ..countInfoRoom =
                                                    (CountInfoRoom()
                                                      ..soLuongPhong =
                                                          _soLuongPhong
                                                      ..soluongNguoiLon =
                                                          _soLuongNguoiLon
                                                      ..soLuongTreEm =
                                                          _soLuongTreEm)
                                                ..idPhong = phongConTrong[
                                                        Random().nextInt(
                                                            phongConTrong
                                                                .length)]
                                                    .id,
                                            );
                                            controllerPersistent.jumpToTab(2);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.blue.shade300,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 2.5),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 25,
                                              vertical: 10,
                                            ),
                                            child: Text(
                                              'Đặt ngay',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: _width / 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                ),
                                width: _width / 1.1,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        CalendarCustom(
                                          context,
                                          _ngayDen,
                                          _ngayDi,
                                          roomInfo.ngayDaDat,
                                        ).then((value) {
                                          DateBook dateBook =
                                              Provider.of<PRoom>(context,
                                                      listen: false)
                                                  .dateBook!;
                                          setState(() {
                                            _ngayDi = dateBook.timeCheckout!;
                                            _ngayDen = dateBook.timeCheckin!;
                                          });
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2.5),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    size: _width / 13,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Ngày đến',
                                                        style: TextStyle(
                                                          fontSize: _width / 25,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${DateFormat('dd/MM/yyyy').format(_ngayDen)}',
                                                        style: TextStyle(
                                                          fontSize: _width / 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    size: _width / 13,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Ngày đi',
                                                        style: TextStyle(
                                                          fontSize: _width / 25,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${DateFormat('dd/MM/yyyy').format(_ngayDi)}',
                                                        style: TextStyle(
                                                          fontSize: _width / 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet<int>(
                                            isDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomCountNumber(
                                                soLuongPhong: _soLuongPhong,
                                                soluongNguoiLon:
                                                    _soLuongNguoiLon,
                                                soLuongTreEm: _soLuongTreEm,
                                              );
                                            }).then((value) {
                                          setState(() {
                                            final countInfo =
                                                Provider.of<PRoom>(context,
                                                        listen: false)
                                                    .countInfo!;
                                            _soLuongNguoiLon =
                                                countInfo.soluongNguoiLon;
                                            _soLuongTreEm =
                                                countInfo.soLuongTreEm;
                                            _soLuongNguoi = _soLuongNguoiLon +
                                                _soLuongTreEm;
                                            _soLuongPhong =
                                                countInfo.soLuongPhong;
                                          });
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2.5),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.person_3,
                                              size: _width / 13,
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Khách Số lượng phòng',
                                                  style: TextStyle(
                                                    fontSize: _width / 25,
                                                  ),
                                                ),
                                                Text(
                                                  '$_soLuongNguoi người, $_soLuongPhong phòng',
                                                  style: TextStyle(
                                                    fontSize: _width / 20,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (roomInfo.ngayDaDat
                                                    .where((info) =>
                                                        _ngayDen.compareTo(info
                                                                .timeCheckin!) >=
                                                            0 &&
                                                        _ngayDen.compareTo(info
                                                                .timeCheckout!) <=
                                                            0)
                                                    .map((e) => e.room)
                                                    .toSet()
                                                    .length ==
                                                roomInfo.soLuongPhong ||
                                            roomInfo.ngayDaDat
                                                    .where((info) =>
                                                        _ngayDi.compareTo(info
                                                                .timeCheckin!) >=
                                                            0 &&
                                                        _ngayDi.compareTo(info
                                                                .timeCheckout!) <=
                                                            0)
                                                    .map((e) => e.room)
                                                    .toSet()
                                                    .length ==
                                                roomInfo.soLuongPhong) {
                                          ackAlert(
                                            context,
                                            'Tìm không thấy phòng trống',
                                          );
                                        } else {
                                          if (_soLuongNguoi >
                                              roomInfo.soNgLon +
                                                  roomInfo.soTreEm) {
                                            ackAlert(
                                              context,
                                              'Số lượng người không phù hợp',
                                            );
                                            return;
                                          }

                                          int flagCheckSumRoom = 0;
                                          int maxCountRoom = 0;
                                          for (DateTime d = _ngayDen;
                                              d.compareTo(_ngayDi) <= 0;
                                              d = d.add(Duration(days: 1))) {
                                            flagCheckSumRoom = roomInfo
                                                .ngayDaDat
                                                .where((info) =>
                                                    d.compareTo(info
                                                            .timeCheckin!) >=
                                                        0 &&
                                                    d.compareTo(info
                                                            .timeCheckout!) <=
                                                        0)
                                                .map((e) => e.room)
                                                .toSet()
                                                .length;

                                            if (flagCheckSumRoom ==
                                                roomInfo.soLuongPhong) {
                                              ackAlert(
                                                context,
                                                'Tìm không thấy phòng trống',
                                              );
                                              return;
                                            }
                                            if (maxCountRoom <
                                                flagCheckSumRoom) {
                                              maxCountRoom = flagCheckSumRoom;
                                            }
                                          }
                                          print(
                                              '=======maxCountRoom: $maxCountRoom');
                                          if (_soLuongPhong >
                                              roomInfo.soLuongPhong -
                                                  maxCountRoom) {
                                            ackAlert(
                                              context,
                                              'Số lượng phòng trống không đủ',
                                            );
                                            return;
                                          }
                                          setState(() {
                                            _hasRoom = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.orange.shade300,
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2.5),
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Kiểm tra tình trạng',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _width / 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 35),
                        _title('Thông tin đánh giá'),
                        const SizedBox(height: 25),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: roomInfo.rates.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              width: _width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  width: .6,
                                  color: Colors.black26,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            roomInfo.rates[index].userInfo.avt,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            height: _width / 5.5,
                                            width: _width / 5.5,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(365),
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) {
                                          return Container(
                                            height: _width / 5.5,
                                            width: _width / 5.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(365),
                                              border: Border.all(
                                                width: .5,
                                                color: Colors.black26,
                                              ),
                                            ),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            height: _width / 5.5,
                                            width: _width / 5.5,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(kAvtNull),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(365),
                                              border: Border.all(
                                                width: .5,
                                                color: Colors.black26,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '${roomInfo.rates[index].userInfo.hoTen}',
                                          style: TextStyle(
                                            fontSize: _width / 19,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${oCcyStar.format(roomInfo.rates[index].binhChon)}',
                                            style: TextStyle(
                                              fontSize: _width / 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          RadiantGradientMask(
                                            child: Icon(
                                              CupertinoIcons.star_fill,
                                              size: _width / 16,
                                            ),
                                            gradient: [
                                              Colors.deepOrange,
                                              Colors.orange.shade500,
                                              Colors.orange.shade200,
                                              Colors.yellow,
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${roomInfo.rates[index].binhLuan}',
                                          style: TextStyle(
                                            fontSize: _width / 22,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 25),
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${DateFormat('dd/MM/yyyy hh:mm:ss a').format(roomInfo.rates[index].ngTao)}',
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: _width / 25,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(CupertinoIcons.back),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCountNumber extends StatefulWidget {
  CustomCountNumber({
    super.key,
    required this.soLuongPhong,
    required this.soLuongTreEm,
    required this.soluongNguoiLon,
  });
  int soluongNguoiLon;
  int soLuongTreEm;
  int soLuongPhong;

  @override
  State<CustomCountNumber> createState() => _CustomCountNumberState();
}

class _CustomCountNumberState extends State<CustomCountNumber> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Số lượng người lớn:'),
              const SizedBox(width: 25),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soluongNguoiLon > 1) {
                            widget.soluongNguoiLon--;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      child: Text(
                        '${widget.soluongNguoiLon}',
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soluongNguoiLon < 10) {
                            widget.soluongNguoiLon++;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(50)),
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Số lượng trẻ em:'),
              const SizedBox(width: 25),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soLuongTreEm > 0) {
                            widget.soLuongTreEm--;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      child: Text(
                        '${widget.soLuongTreEm}',
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soLuongTreEm < 10) {
                            widget.soLuongTreEm++;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(50)),
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text('Số lượng phòng:'),
          //     const SizedBox(width: 25),
          //     Container(
          //       child: Row(
          //         children: [
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 if (widget.soLuongPhong > 1) {
          //                   widget.soLuongPhong--;
          //                 }
          //               });
          //             },
          //             child: Container(
          //               alignment: Alignment.center,
          //               decoration: BoxDecoration(
          //                 color: Colors.amber,
          //                 borderRadius: BorderRadius.horizontal(
          //                   left: Radius.circular(50),
          //                 ),
          //               ),
          //               child: Icon(
          //                 Icons.remove,
          //                 size: 20,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 20),
          //           Container(
          //             alignment: Alignment.center,
          //             width: 20,
          //             child: Text(
          //               '${widget.soLuongPhong}',
          //             ),
          //           ),
          //           const SizedBox(width: 20),
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 if (widget.soLuongPhong < 10) {
          //                   widget.soLuongPhong++;
          //                 }
          //               });
          //             },
          //             child: Container(
          //               alignment: Alignment.center,
          //               decoration: BoxDecoration(
          //                 color: Colors.amber,
          //                 borderRadius: BorderRadius.horizontal(
          //                     right: Radius.circular(50)),
          //               ),
          //               child: Icon(
          //                 CupertinoIcons.plus,
          //                 size: 20,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              CountInfoRoom countInfoRoom = CountInfoRoom();
              countInfoRoom
                ..soLuongPhong = widget.soLuongPhong
                ..soLuongTreEm = widget.soLuongTreEm
                ..soluongNguoiLon = widget.soluongNguoiLon;

              Provider.of<PRoom>(context, listen: false)
                  .setCountInfo(countInfoRoom);
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade300,
              ),
              margin: EdgeInsets.symmetric(vertical: 2.5),
              padding: EdgeInsets.all(10),
              child: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white, fontSize: _width / 18),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
