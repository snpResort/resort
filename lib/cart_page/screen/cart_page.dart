import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
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
  double giaSale = 0;
  double total = 0;
  bool _isLoad = false;
  bool _isLoadThanhToan = false;

  PRoom? pRoom;
  User? user;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    pRoom = Provider.of<PRoom>(context, listen: true);
    user = Provider.of<PUser>(context).user;
  }

  @override
  Widget build(BuildContext context) {
    final oCcyMoney = NumberFormat("#,##0");
    final _width = MediaQuery.of(context).size.width;
    final _heightAppBar = _width / 6.3;
    final _height = MediaQuery.of(context).size.height;
    total = 0;

    final listRoomsBook = Expanded(
      flex: 4,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            pRoom!.infoBook.isEmpty
                ? Image.asset(
                    kCartEmpty,
                    height: _height / 1.2,
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pRoom!.infoBook.length,
                          itemBuilder: (context, index) {
                            final infoBook = pRoom!.infoBook;
                            final roomInfo = pRoom!.room;
                            final ngayO =
                                (infoBook[index].ngayDat.timeCheckout!.day -
                                    infoBook[index].ngayDat.timeCheckin!.day);
                            final gia = infoBook.isEmpty
                                ? 0
                                : infoBook[index].gia * ngayO;
                            total += gia;
                            print('========================');
                            print('======ngayO : $ngayO========');

                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 25),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black38,
                                      width: .5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${infoBook[index].tenLP}',
                                          style: TextStyle(
                                            fontSize: _width / 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Container(
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
                                              color: Colors.orange.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<PRoom>(context, listen: false)
                                        .deleteInfoBook(infoBook[index]);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    CupertinoIcons.xmark,
                                    size: _width / 20,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    getSale(id: _idSaleController.text)
                                        .then((khuyenMai) {
                                      if (_idSaleController.text.isEmpty) {
                                        ackAlert(
                                          context,
                                          'Vui lòng nhập mã khuyến mãi',
                                        );
                                      }
                                      setState(() {
                                        isSale = true;
                                        giaSale = total - total * khuyenMai;
                                        if (total == giaSale) {
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
                                          child: CircularProgressIndicator(),
                                        )
                                      : Container(
                                          height: 45,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.orange,
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
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: _heightAppBar / 1.15),
            listRoomsBook,
            const Divider(
              height: 10,
              thickness: 5,
            ),
            pRoom!.infoBook.isNotEmpty
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                fontSize: _width / 19,
                              ),
                            ),
                            Text(
                              '${oCcyMoney.format(total)} ₫',
                              style: TextStyle(
                                decoration: isSale
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: _width / 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.orange.shade800,
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
                                onPressed: pRoom!.infoBook.isEmpty
                                    ? null
                                    : () {
                                        Future.wait(
                                            pRoom!.infoBook.map((infoBook) {
                                          return bookedRequest(
                                              username: user!.username,
                                              soLuongNguoiTH: infoBook
                                                  .countInfoRoom
                                                  .soluongNguoiLon,
                                              soLuongTreEm: infoBook
                                                  .countInfoRoom.soLuongTreEm,
                                              gia: isSale ? giaSale : total,
                                              ngayDat:
                                                  infoBook.ngayDat.timeCheckin!,
                                              ngayTra: infoBook
                                                  .ngayDat.timeCheckout!,
                                              idPhong: infoBook.idPhong);
                                        })).then((bookRoom) {
                                          if (bookRoom
                                              .every((element) => element)) {
                                            succesAlert(
                                              context,
                                              'Đặt phòng thành công',
                                            );
                                            Provider.of<PRoom>(context,
                                                    listen: false)
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
                                    Colors.orange,
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
                                      color: Colors.white,
                                      fontSize: _width / 18),
                                ),
                              ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        Theme(
          data: ThemeData(
            canvasColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          child: Container(
            width: _width,
            height: _heightAppBar,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(55),
                )),
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              'Giỏ hàng',
              style: TextStyle(
                fontSize: _width / 15,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
