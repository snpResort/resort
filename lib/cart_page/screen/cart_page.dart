import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/cart_page/request/book_room.dart';
import 'package:resort/cart_page/request/sale_request.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/widgets/success_alert.dart';
import 'package:resort/widgets/wrong_alert.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static String id = '/CartPage';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController _idSaleController = TextEditingController();
  bool isSale = false;
  double gia = 0;
  double giaSale = 0;
  bool _isLoad = false;
  bool _isLoadThanhToan = false;

  @override
  Widget build(BuildContext context) {
    final pRoom = Provider.of<PRoom>(context, listen: true);
    final user = Provider.of<PUser>(context).user;

    final infoBook = pRoom.infoBook;
    final roomInfo = pRoom.room;
    final _width = MediaQuery.of(context).size.width;
    gia = infoBook.isEmpty
        ? 0
        : roomInfo!.gia *
            (infoBook[0].ngayDat.timeCheckout!.day -
                infoBook[0].ngayDat.timeCheckin!.day +
                1);

    final oCcyMoney = NumberFormat("#,##0");

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 6),
          Text(
            'Giỏ hàng',
            style: TextStyle(fontSize: _width / 16),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  infoBook.isEmpty
                      ? Image.asset(
                          kCartEmpty,
                          height: MediaQuery.of(context).size.height / 1.5,
                        )
                      : Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${roomInfo!.ten}',
                                  style: TextStyle(
                                    fontSize: _width / 18,
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
                                                  fontSize: _width / 25,
                                                ),
                                              ),
                                              Text(
                                                '${DateFormat('dd/MM/yyyy').format(infoBook[0].ngayDat.timeCheckin!)}',
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
                                                '${DateFormat('dd/MM/yyyy').format(infoBook[0].ngayDat.timeCheckout!)}',
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
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 2.5),
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
                                          '${infoBook[0].countInfoRoom.soluongNguoiLon + infoBook[0].countInfoRoom.soLuongTreEm} người, ${infoBook[0].countInfoRoom.soLuongPhong} phòng',
                                          style: TextStyle(
                                            fontSize: _width / 20,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tổng giá phòng',
                                    style: TextStyle(
                                      fontSize: _width / 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${oCcyMoney.format(gia)} ₫',
                                    style: TextStyle(
                                      fontSize: _width / 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Mã giảm giá',
                                  style: TextStyle(
                                    fontSize: _width / 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        controller: _idSaleController,
                                        decoration: InputDecoration(
                                          labelText: 'Nhập mã giảm giá',
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: .5,
                                              color: Color(0x99000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          getSale(id: _idSaleController.text)
                                              .then((khuyenMai) {
                                            if (_idSaleController
                                                .text.isEmpty) {
                                              ackAlert(
                                                context,
                                                'Vui lòng nhập mã khuyến mãi',
                                              );
                                            }
                                            setState(() {
                                              isSale = true;
                                              giaSale = gia - gia * khuyenMai;
                                              if (gia == giaSale) {
                                                isSale = false;
                                                giaSale = 0;
                                              }
                                              _isLoad = false;
                                            });
                                            print('khuyenMai-- $khuyenMai');
                                          });
                                          setState(() {
                                            _isLoad = true;
                                          });
                                        },
                                        child: _isLoad
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Container(
                                                height: 45,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.orange.shade800,
                                                ),
                                                child: Text(
                                                  'Áp dụng',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: _width / 25,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 10,
            thickness: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng cộng ${infoBook.isNotEmpty ? '(${infoBook[0].ngayDat.timeCheckout!.day - infoBook[0].ngayDat.timeCheckin!.day + 1} đêm)' : ''}',
                      style: TextStyle(
                        fontSize: _width / 19,
                      ),
                    ),
                    Text(
                      '${oCcyMoney.format(gia)} ₫',
                      style: TextStyle(
                        decoration: isSale
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: _width / 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                if (isSale)
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${oCcyMoney.format(giaSale)} ₫',
                      style: TextStyle(
                        fontSize: _width / 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
                _isLoadThanhToan
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextButton(
                        onPressed: infoBook.isEmpty
                            ? null
                            : () {
                                bookedRequest(
                                        username: user!.username,
                                        soLuongNguoiTH: infoBook[0]
                                            .countInfoRoom
                                            .soluongNguoiLon,
                                        soLuongTreEm: infoBook[0]
                                            .countInfoRoom
                                            .soLuongTreEm,
                                        gia: isSale ? giaSale : gia,
                                        ngayDat:
                                            infoBook[0].ngayDat.timeCheckin!,
                                        ngayTra:
                                            infoBook[0].ngayDat.timeCheckout!,
                                        idPhong: infoBook[0].idPhong)
                                    .then((bookRoom) {
                                  if (bookRoom) {
                                    succesAlert(
                                      context,
                                      'Đặt phòng thành công',
                                    );
                                    Provider.of<PRoom>(context, listen: false)
                                        .deleteAllInfoBook();

                                    setState(() {
                                      giaSale = 0;
                                      isSale = false;
                                      _idSaleController.clear();
                                      _isLoadThanhToan = false;
                                    });
                                  }
                                });
                                setState(() {
                                  _isLoadThanhToan = true;
                                });
                              },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.orange.shade800,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                              horizontal: _width / 4,
                              vertical: 13,
                            ),
                          ),
                        ),
                        child: Text(
                          'Thanh toán',
                          style: TextStyle(
                              color: Colors.white, fontSize: _width / 18),
                        ),
                      ),
                const SizedBox(height: 70),
              ],
            ),
          )
        ],
      ),
    );
  }
}
