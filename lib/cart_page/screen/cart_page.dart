import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/cart_page/request/book_room.dart';
import 'package:resort/cart_page/request/sale_request.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/home_page/request/room_request.dart';
import 'package:resort/main.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/success_alert.dart';
import 'package:resort/widgets/warning_alert.dart';
import 'package:resort/widgets/wrong_alert.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static String id = '/CartPage';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _idSaleController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isSale = false;
  double giaSale = 0;
  double saleMemeber = 0;
  double sale = 0;
  double total = 0;
  int sumInvite = 0;
  bool _isLoad = false;
  bool _isLoadThanhToan = false;

  PRoom? pRoom;
  User? user;
  final oCcyMoney = NumberFormat("#,##0");

  late AnimationController _controller;
  late Animation _animation;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 10.0, end: 200.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    pRoom = Provider.of<PRoom>(context, listen: true);
    user = Provider.of<PUser>(context).user;

    sumInvite = pRoom!.infoBook.isNotEmpty 
        ? pRoom!.infoBook.first.ngayDat.soNgayO()
        : 0;

    total = pRoom!.infoBook.isNotEmpty
        ? pRoom!.infoBook
            .map((e) => e.gia)
            .reduce((value, element) => value + element)
        : 0;

    // isSale = pRoom!.infoBook.isEmpty;
    giaSale = total - total * sale;
    saleMemeber = total * (user?.member.khuyenMai ?? 0);

    // if (pRoom!.infoBook.isEmpty) {
    //   _idSaleController.clear();

    //   print('empty ===================');
    // }
    print(
        '========== _idSaleController = ${_idSaleController.text} ===================');
    print(
        '========== pRoom!.infoBook.isEmpty = ${pRoom!.infoBook.isEmpty} ===================');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    final _width = MediaQuery.of(context).size.width;
    final _heightAppBar = _width / 6.3;
    final _height = MediaQuery.of(context).size.height;

    if (_focusNode.hasFocus) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    final listRoomsBook = Expanded(
      flex: 4,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            pRoom!.infoBook.isEmpty
                ? Image.asset(
                    kCartEmpty,
                    height: _height / 1.2,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: _heightAppBar - _width / 15,
                    ),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pRoom!.infoBook.length,
                          itemBuilder: (context, index) {
                            final infoBook = pRoom!.infoBook;

                            print('========================');
                            print('=====price: ${infoBook[index].gia}======');
                            print(
                                '=====checkout: ${infoBook[index].ngayDat.timeCheckout!.toString()}======');
                            print(
                                '=====checkin: ${infoBook[index].ngayDat.timeCheckin!.toString()}======');
                            // print('======ngayO : $ngayO========');

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
                                                        '${DateFormat('dd/MM/yyyy').format(infoBook[index].ngayDat.timeCheckin!)}',
                                                        style: TextStyle(
                                                          fontSize: (_width - 20) / 20,
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
                                                        '${DateFormat('dd/MM/yyyy').format(infoBook[index].ngayDat.timeCheckout!)}',
                                                        style: TextStyle(
                                                          fontSize: (_width - 20) / 20,
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
                                                  '${infoBook[index].countInfoRoom.soluongNguoiLon + infoBook[index].countInfoRoom.soLuongTreEm} người, ${infoBook[index].countInfoRoom.soLuongPhong} phòng',
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
                                            '${oCcyMoney.format(infoBook[index].gia)} ₫',
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
                                    messageAlert(
                                      context, 
                                      'Bạn có muốn xoá ${infoBook[index].tenLP} ra khỏi danh sách đặt phòng không?',
                                      onPressCancel: () {},
                                      onPressOK: () {
                                        Provider.of<PRoom>(context, listen: false)
                                        .deleteInfoBook(infoBook[index]);
                                      }
                                    );
                                    

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
                                  focusNode: _focusNode,
                                  controller: _idSaleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nhập mã giảm giá',
                                    border: OutlineInputBorder(
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
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    getSale(id: _idSaleController.text)
                                        .then((khuyenMai) {
                                      if (_idSaleController.text.isEmpty) {
                                        messageAlert(
                                          context,
                                          'Vui lòng nhập mã khuyến mãi'
                                        );
                                        giaSale = total;
                                      }
                                      else if (khuyenMai == 0) {
                                        _idSaleController.clear();
                                        messageAlert(
                                          context,
                                          'Mã giảm giá không phù hợp.\nVui lòng kiểm tra lại',
                                        );
                                        giaSale = total;
                                      } else {
                                        setState(() {
                                          isSale = true;
                                          sale = khuyenMai;
                                          giaSale = total - total * sale;
                                          _idSaleController.clear();
                                        });
                                        print('khuyenMai-- $khuyenMai');
                                      }
                                      setState(() {
                                        _isLoad = false;
                                      });
                                    });
                                    setState(() {
                                      _isLoad = true;
                                    });
                                  },
                                  child: _isLoad
                                      ? Center(
                                          child: LoadingWidget(
                                              color: Colors.orange),
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
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Todo show select method pay
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phương thức thanh toán',
                                style: TextStyle(
                                  fontSize: _width / 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                        SizedBox(height: _animation.value),
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
                              'Tổng cộng ($sumInvite đêm):',
                              style: TextStyle(
                                fontSize: _width / 19,
                              ),
                            ),
                            Text(
                              '${oCcyMoney.format(total)} ₫',
                              style: TextStyle(
                                decoration: isSale || saleMemeber != 0
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: _width / 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                        if (isSale || saleMemeber != 0)
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${oCcyMoney.format(giaSale - saleMemeber)} ₫',
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
                                child: LoadingWidget(color: Colors.orange,),
                              )
                            : TextButton(
                                onPressed: pRoom!.infoBook.isEmpty
                                    ? null
                                    : () {
                                        if (!DBUser.hasLogin()) {
                                          messageAlert(
                                            context,
                                            'Vui lòng đăng nhập để thực hiện thanh toán',
                                            onPressOK: () {
                                              PersistentNavBarNavigator
                                                  .pushNewScreenWithRouteSettings(
                                                context,
                                                screen: ScreenLogin(),
                                                withNavBar: false,
                                                settings: RouteSettings(
                                                    name: ScreenLogin.id),
                                              );
                                            },
                                            onPressCancel: () {}
                                          );
                                          return;
                                        } else {
                                          messageAlert(
                                            context, 'Xác nhận đặt phòng',
                                            color: Colors.blue.shade300,
                                            onPressCancel: () {
                                              setState(() {
                                                _isLoadThanhToan = false;
                                              });
                                            },
                                            onPressOK: () {
                                              Future.wait(
                                                [bookedRequest(
                                                    username: user!.username,
                                                    soLuongNguoiTH: pRoom!.infoBook.map((e) => e.countInfoRoom.soluongNguoiLon).reduce((value, element) => value + element),
                                                    soLuongTreEm: pRoom!.infoBook.map((e) => e.countInfoRoom.soLuongTreEm).reduce((value, element) => value + element),
                                                    gia: isSale || saleMemeber != 0 ? giaSale - saleMemeber : total,
                                                    ngayDat: pRoom!.infoBook[0].ngayDat.timeCheckin!,
                                                    ngayTra: pRoom!.infoBook[0].ngayDat.timeCheckout!,
                                                    idPhong: pRoom!.infoBook.map((e) => e.idPhong).expand((element) => element).toList()
                                                )]
                                              ).then((bookRoom) async {
                                                if (bookRoom
                                                    .every((element) => element)) {
                                                  final roomData = await roomRequest();

                                                  Provider.of<PRoom>(context, listen: false).setRooms(roomData??[]);
                                                  
                                                  messageAlert(
                                                    context,
                                                    'Đặt phòng thành công',
                                                    color: Colors.blue.shade400,
                                                    onPressOK: () {
                                                      Provider.of<PRoom>(context, listen: false).deleteAllInfoBook();

                                                      setState(() {
                                                        sale = 0;
                                                        giaSale = 0;
                                                        isSale = false;
                                                        _idSaleController.clear();
                                                        _isLoadThanhToan = false;
                                                      });
                                                    }
                                                  );
                                                }
                                              });
                                            }
                                          );
                                        }
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
            height: _heightAppBar + _width / 15,
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
