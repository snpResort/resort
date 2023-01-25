import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:resort/constant/app_string.dart';
    
class BookedInfoPage extends StatefulWidget {
  BookedInfoPage({Key? key, this.bookInfo}) : super(key: key);

  static String id = 'BookedInfoPage';

  dynamic bookInfo;

  @override
  _BookedInfoPageState createState() => _BookedInfoPageState();
}

class _BookedInfoPageState extends State<BookedInfoPage> {
  final oCcyMoney = NumberFormat("#,##0");  

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var _soNgayO = DateTime.parse(widget.bookInfo['NgayTra']).difference(DateTime.parse(widget.bookInfo['NgayDat'])).inDays + 1;

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
          'Thông tin đặt phòng',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
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
                  'Mã: ${widget.bookInfo['Id']}',
                  style: TextStyle(
                    fontSize: _width / 15,
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
                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.bookInfo['NgayDat']))}',
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
                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.bookInfo['NgayTra']))}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số ngày ở',
                    style: TextStyle(
                      fontSize: (_width - 40) / 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '$_soNgayO',
                    style: TextStyle(
                      fontSize: (_width - 40) / 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số lượng người lớn',
                    style: TextStyle(
                      fontSize: (_width - 40) / 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${widget.bookInfo['SoLuongNguoiTH']}',
                    style: TextStyle(
                      fontSize: (_width - 40) / 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số lượng trẻ em',
                    style: TextStyle(
                      fontSize: (_width - 40) / 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${widget.bookInfo['SoLuongTreEm']}',
                    style: TextStyle(
                      fontSize: (_width - 40) / 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách phòng',
                  style: TextStyle(fontSize: (_width - 40) / 15),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Phòng',
                      style: TextStyle(fontSize: (_width - 40) / 22, color: Colors.orange, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Số lượng',
                      style: TextStyle(fontSize: (_width - 40) / 22, color: Colors.orange, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Giá',
                        style: TextStyle(fontSize: (_width - 40) / 22, color: Colors.orange, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.bookInfo['ChiTiet'].length,
                itemBuilder: (context, index) {
                  final ct = widget.bookInfo['ChiTiet'];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${ct[index]['TenLoai']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: (_width - 40) / 18),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            '${ct[index]['SoLuong']}',
                            style: TextStyle(fontSize: (_width - 40) / 18),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${oCcyMoney.format(ct[index]['Gia'] * ct[index]['SoLuong'] * _soNgayO)} ₫',
                              style: TextStyle(fontSize: (_width - 40) / 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1.5, color: Colors.black26, height: 0),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Tổng',
                      style: TextStyle(
                        fontSize: (_width - 40) / 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      (widget.bookInfo['ChiTiet'] as List).length == 1 
                        ? '${widget.bookInfo['ChiTiet'][0]['SoLuong']}'
                        : '${(widget.bookInfo['ChiTiet'] as List).reduce((value, element) => value['SoLuong'] + element['SoLuong'])}',
                      style: TextStyle(fontSize: (_width - 40) / 18),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${oCcyMoney.format(widget.bookInfo['DonGia'])} ₫',
                        style: TextStyle(
                          fontSize: (_width - 40) / 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              Container(
                child: QrImage(
                  data: '${widget.bookInfo['Id']}',
                  version: QrVersions.auto,
                  size: 240,
                  gapless: false,
                  embeddedImage: AssetImage(kLogoApp),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(80, 80),
                  ),
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text(
                          'Đã xảy ra lỗi!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }
}