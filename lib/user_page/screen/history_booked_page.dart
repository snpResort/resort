import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/user_page/request/history_book_request.dart';
import 'package:resort/user_page/screen/booked_info_page.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/message_alert.dart';
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
    final _height = MediaQuery.of(context).size.height;

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
          'Lịch sử đặt phòng',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder(
              future: historyBookedRoom(userID: user!.idTK),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  messageAlert(context, 'Đã có lỗi xảy ra');
                  return SizedBox();
                } else if (!snapshot.hasData) {
                  return Container(
                    width: _width,
                    height: _height,
                    child: Center(
                      child: LoadingWidget(color: Colors.yellow.shade700),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final bookInfo = snapshot.data[index];
                    return GestureDetector(
                      onTap:() {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => BookedInfoPage(bookInfo: bookInfo,),)
                        );
                      },
                      child: Container(
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
                              child: Text(
                                '${bookInfo['Id']}',
                                style: TextStyle(
                                  fontSize: _width / 18,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w400,
                                ),
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
                                                fontSize: (_width - 40) / 25,
                                              ),
                                            ),
                                            Text(
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(bookInfo['NgayDat']))}',
                                              style: TextStyle(
                                                fontSize: (_width - 40) / 20,
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
                                                fontSize: (_width - 40) / 25,
                                              ),
                                            ),
                                            Text(
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(bookInfo['NgayTra']))}',
                                              style: TextStyle(
                                                fontSize: (_width - 40) / 20,
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
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Danh sách phòng',
                                style: TextStyle(fontSize: (_width - 40) / 19),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Phòng',
                                    style: TextStyle(fontSize: (_width - 40) / 21),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    'Số lượng',
                                    style: TextStyle(fontSize: (_width - 40) / 21),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Giá',
                                      style: TextStyle(fontSize: (_width - 40) / 21),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bookInfo['ChiTiet'].length,
                              itemBuilder: (context, index) {
                                final ct = bookInfo['ChiTiet'];
                                var _soNgayO = DateTime.parse(bookInfo['NgayTra']).difference(DateTime.parse(bookInfo['NgayDat'])).inDays + 1;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${ct[index]['TenLoai']}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: (_width - 40) / 21),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        '${ct[index]['SoLuong']}',
                                        style: TextStyle(fontSize: (_width - 40) / 21),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${oCcyMoney.format(ct[index]['Gia'] * ct[index]['SoLuong'] * _soNgayO)} ₫',
                                          style: TextStyle(fontSize: (_width - 40) / 21),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng giá phòng',
                                  style: TextStyle(
                                    fontSize: (_width - 40) / 19,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${oCcyMoney.format(bookInfo['DonGia'])} ₫',
                                  style: TextStyle(
                                    fontSize: (_width - 40) / 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    );
  }
}
