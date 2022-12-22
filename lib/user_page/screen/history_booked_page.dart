import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/user_page/request/history_book_request.dart';
import 'package:resort/widgets/wrong_alert.dart';

class HistoryBooked extends StatefulWidget {
  const HistoryBooked({super.key});
  static String id = 'HistoryBooked';
  @override
  State<HistoryBooked> createState() => _HistoryBookedState();
}

class _HistoryBookedState extends State<HistoryBooked> {
  User? user;

  final oCcyMoney = NumberFormat("#,##0");
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    user = Provider.of<PUser>(context).user;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Lịch sự đặt phòng',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder(
                future: historyBookedRoom(userID: user!.idTK),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    ackAlert(context, 'Đã có lỗi xảy ra');
                    return SizedBox();
                  } else if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final bookInfo = snapshot.data[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: .5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${bookInfo['TenLoaiPhong']}',
                                    style: TextStyle(
                                      fontSize: _width / 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${bookInfo['Id']}',
                                    style: TextStyle(
                                      fontSize: _width / 18,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 2.5),
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
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(bookInfo['NgayDat']))}',
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
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(bookInfo['NgayTra']))}',
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
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng giá phòng',
                                  style: TextStyle(
                                    fontSize: _width / 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${oCcyMoney.format(bookInfo['DonGia'])} ₫',
                                  style: TextStyle(
                                    fontSize: _width / 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
