import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/model/date_book.dart';
import 'package:resort/home_page/model/rate.dart';
import 'package:resort/home_page/model/room.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/home_page/request/room_request.dart';
import 'package:resort/home_page/screen/room_info_page.dart';
import 'package:resort/home_page/screen/room_search.dart';
import 'package:resort/home_page/screen/rooms_info.dart';
import 'package:resort/widgets/calendar_custom.dart';
import 'package:resort/widgets/carouse_slider.dart';
import 'package:resort/widgets/count_info.dart';
import 'package:resort/widgets/custom_lp.dart';
import 'package:resort/widgets/gradient_mask.dart';
import 'package:resort/widgets/info_alert.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/star_clipper.dart';
import 'package:resort/widgets/warning_alert.dart';
import 'package:resort/widgets/wrong_alert.dart';


final oCcy = new NumberFormat("#.#");
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String id = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final banners = [
    'https://snpresort.github.io/images/panel/panel1.jpg',
    'https://snpresort.github.io/images/panel/panel2.jpg',
    'https://snpresort.github.io/images/panel/panel3.jpg',
    'https://snpresort.github.io/images/panel/panel4.jpg',
    'https://snpresort.github.io/images/panel/panel5.jpg',
  ];

  late bool isLoad;
  late bool isLoadData = false;
  List<Room> rooms = [];

  DateTime _ngayDen = DateTime.now();
  DateTime _ngayDi = DateTime.now().add(Duration(days: 1));

  TextEditingController _priceController = TextEditingController();

  int _tempSoLuongNguoiLon = 1;
  int _tempSoLuongTreEm = 0;
  int _tempSoLuongNguoi = 0;
  int _tempSoLuongPhong = 1;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      Provider.of<PUser>(context, listen: false);
      rooms = Provider.of<PRoom>(context, listen: true).rooms ?? [];
    } catch (e) {
      print('========= error: ${e}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    roomRequest().then((value) {
      print('==================== vale: $value');
      try {
        Provider.of<PRoom>(context, listen: false).setRooms(value!);
      } catch (e) {
        print('------------e: $e');
      }
      setState(() {
        isLoad = false;
      });
    });

    _tempSoLuongNguoi = _tempSoLuongNguoiLon + _tempSoLuongTreEm;

    isLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final isLogin = Provider.of<PUser>(context).isLogin;
    final user = isLogin ? Provider.of<PUser>(context).user : null;
    final favRoom = List<Room>.from(rooms);
    if (!isLoad) {
      favRoom.sort((a, b) => avg_rate(b.rates).compareTo(avg_rate(a.rates)));
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    return Stack(
      children: [
        Image.asset(
          kBg1,
          fit: BoxFit.fill,
          height: _height,
          width: _width,
        ),
        isLoad
            ? Center(
                child: LoadingWidget(),
              )
            : rooms.length == 0
                ? Builder(
                    builder: (context) {
                      ackAlert(context, 'Có lỗi đã xảy ra vui lòng thử lại');

                      return const SizedBox();
                    },
                  )
                : Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SafeArea(
                      child: RefreshIndicator(
                        onRefresh: () { 
                          setState(() {
                            isLoadData = true;
                          });
                          roomRequest().then((value) {
                            final pRoom = Provider.of<PRoom>(context, listen: false);
                            pRoom.setRooms(value!);
                    
                            setState(() {
                              isLoadData = false;
                            });
                          });
                          return Future.delayed(Duration(milliseconds: 500));
                        },
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: SafeArea(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            kLogoApp,
                                            height: 95,
                                            width: 95,
                                          ),
                                          const SizedBox(height: 10),
                                          if (user != null)
                                            Text(
                                              'Xin chào, ${user.hoTen}',
                                              style: TextStyle(
                                                fontSize: _width / 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (!Provider.of<PUser>(context).isLogin)
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: IconButton(
                                          onPressed: () {
                                            PersistentNavBarNavigator
                                                .pushNewScreenWithRouteSettings(
                                              context,
                                              screen: ScreenLogin(),
                                              withNavBar: false,
                                              settings: RouteSettings(
                                                  name: ScreenLogin.id),
                                            );
                                          },
                                          icon: Icon(
                                            CupertinoIcons.person_crop_circle,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                CarouseSlider(banners: banners),
                                const SizedBox(height: 40),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                  ),
                                  width: _width,
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _priceController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Giá',
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(Icons.search),
                                        ),
                                        style: TextStyle(fontSize: _width / 21),
                                        onChanged: (value) {
                                          value = '${formNum(value.replaceAll(',', ''),)}';
                                          _priceController.value = TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                              offset: value.length,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 5,),
                                      GestureDetector(
                                        onTap: () {
                                          CalendarCustom(
                                            context,
                                            _ngayDen,
                                            _ngayDi,
                                            [],
                                            true
                                          ).then((value) {
                                            DateBook dateBook = Provider.of<PRoom>(
                                                    context,
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
                                            border: Border.all(width: .6),
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
                                                            fontSize: (_width - 40) / 21,
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
                                                            fontSize: (_width - 40) / 21,
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
                                      const SizedBox(height: 5,),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet<Map<String, int>>(
                                            isDismissible: false,
                                            context: context,
                                            builder:(BuildContext context) {
                                              return CountInfo(
                                                soLuongTreEm: _tempSoLuongTreEm, 
                                                soluongNguoiLon: _tempSoLuongNguoiLon, 
                                                soLuongPhong: _tempSoLuongPhong);
                                          }).then((value) {
                                            setState(() {
                                              if (value != null) {
                                                _tempSoLuongTreEm = value['soLuongTreEm'] ?? 1;
                                                _tempSoLuongNguoiLon = value['soluongNguoiLon'] ?? 1;
                                                _tempSoLuongNguoi = _tempSoLuongNguoiLon + _tempSoLuongTreEm;
                                                _tempSoLuongPhong = value['soLuongPhong'] ?? 1;
                                              }
                                            });
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(width: .6),
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
                                                    '$_tempSoLuongNguoi người, $_tempSoLuongPhong phòng',
                                                    style: TextStyle(
                                                      fontSize: _width / 21,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      GestureDetector(
                                        onTap: () {
                                          if (_priceController.text.isEmpty) {
                                            messageAlert(context, 'Vui lòng nhập giá');
                                          } else {
                                            try {
                                              int.parse(_priceController.text);
                                            } catch (e) {
                                              messageAlert(context, 'Giá không được chứa kí tự đặc biệt');
                                              return;
                                            }
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            // todo: handle search room
                                            print('search ${rooms.length}');
                                          
                                            final searchRoom = rooms.where((room) {
                                              bool flagCheckPrice = room.gia <= int.parse(_priceController.text.replaceAll(',', ''));
                                              //! ===========================================
                                              List<String> roomBooked = [];
                                              for (DateTime d = _ngayDen;
                                                  d.compareTo(_ngayDi) <= 0;
                                                  d = d.add(Duration(days: 1))) {
                                                roomBooked.addAll(room
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
                                              roomBooked = roomBooked.toSet().toList();
                      
                                              final phongConTrong = room.rooms
                                                  .where((_room) => !roomBooked
                                                      .contains(_room.tenPhong))
                                                  .toList();
                      
                                              print('phongConTrong cua p ${room.ten}: ${phongConTrong.length}');
                      
                                              //! ===========================================
                                              bool flagPeople = room.soNgLon >= _tempSoLuongNguoi;
                                              bool flagRoom = phongConTrong.length >= _tempSoLuongPhong;
                      
                                              return flagCheckPrice && flagPeople && flagRoom;
                                            }).toList();
                                            if (searchRoom.length == 0) {
                                              messageAlert(context, 'Không tìm thấy phòng phù hợp\nVui lòng thử lại', color: Colors.blue.shade300);
                                            } else {
                                              // todo: navigator into page room search
                                              PersistentNavBarNavigator.pushNewScreen(
                                                context,
                                                screen: RoomSearch(
                                                  listSearchRoom: searchRoom, 
                                                  datebook: DateBook()
                                                    ..timeCheckin = _ngayDen
                                                    ..timeCheckout = _ngayDi,
                                                ),
                                                withNavBar: false, // OPTIONAL VALUE. True by default.
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation.cupertino,
                                              ).then((value) {
                                                setState(() {
                                                  _priceController.clear();
                                                  _tempSoLuongNguoiLon = 1;
                                                  _tempSoLuongTreEm = 0;
                                                  _tempSoLuongNguoi = _tempSoLuongNguoiLon + _tempSoLuongTreEm;
                                                  _tempSoLuongPhong = 1;
                                                });
                                              });
                                            }
                                          }
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
                                            'Tìm kiếm',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: _width / 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Yêu thích',
                                        style: TextStyle(
                                            fontSize: _width / 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 185,
                                  width: _width,
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    itemCount: 3,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isLoadData = true;
                                          });
                                          Provider.of<PRoom>(context, listen: false)
                                              .setRoom(favRoom.elementAt(index));
                                          PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            screen: RoomInfoPage(),
                                            withNavBar: false, // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.cupertino,
                                          ).then((_) {
                                            // setState(() {
                                            //   isLoadData = true;
                                            // });
                                            // roomRequest().then((value) {
                                            //   print('==================== vale: $value');
                                            //   setState(() {
                                            //     isLoadData = false;
                                            //     try {
                                            //       rooms = value!;
                                            //     } catch (e) {
                                            //       print('------------e: $e');
                                            //     }
                                            //   });
                                            // });
                                            setState(() {
                                              isLoadData = false;
                                            });
                                          });
                                        },
                                        child: favorite_room(
                                          width: _width,
                                          index: index,
                                          room: favRoom.elementAt(index),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 35),
                                _loaiPhong(
                                  width: _width,
                                  rooms: rooms,
                                ),
                                const SizedBox(height: 60),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isLoadData) 
                  Container(
                    height: _height,
                    width: _width,
                    color: Colors.black54,
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  )
      ],
    );
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }
}

class favorite_room extends StatelessWidget {
  const favorite_room({
    Key? key,
    required double width,
    required int index,
    required this.room,
  })  : _width = width,
        _index = index,
        super(key: key);

  final double _width;
  final int _index;
  final Room room;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: customLP_rate(
            width: _width,
            isHorizontal: true,
            title: '${room.ten}',
            price: '${room.gia}',
            amoutCmt: sum_cmt(room.rates),
            rateStar: '${oCcy.format(avg_rate(room.rates))}',
            urlImage: '${room.images[0]}',
          ),
        ),
        Container(
          height: 50,
          width: 50,
          child: ClipPath(
            clipper: StarClipper(3),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow()],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.yellow.shade300,
                    Colors.yellow,
                    Colors.red.shade500,
                  ],
                ),
              ),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      '${_index + 1}',
                      style: TextStyle(
                        fontSize: 30,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.blue[700]!,
                      ),
                    ),
                    // Solid text as fill.
                    Text(
                      '${_index + 1}',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _loaiPhong extends StatelessWidget {
  _loaiPhong({Key? key, required double width, required this.rooms})
      : _width = width,
        super(key: key);

  final double _width;
  List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loại phòng',
                style: TextStyle(
                    fontSize: _width / 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<PRoom>(context, listen: false).setRooms(rooms);
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: RoomsInfo(rooms: rooms),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Text(
                  'Xem thêm',
                  style: TextStyle(
                    fontSize: _width / 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: 4,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () {                
                Provider.of<PRoom>(context, listen: false)
                    .setRoom(rooms.elementAt(index));
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: RoomInfoPage(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: customLP(
                  width: _width,
                  isHorizontal: false,
                  title: '${rooms[index].ten}',
                  price: '${rooms[index].gia}',
                  amoutCmt: sum_cmt(rooms[index].rates),
                  rateStar: '${oCcy.format(avg_rate(rooms[index].rates))}',
                  urlImage: '${rooms[index].images[0]}',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

int sum_cmt(List<Rate> rates) {
  final list_bc = rates.map((e) => e.binhLuan);

  return list_bc.length;
}

double avg_rate(List<Rate> rates) {
  if (rates.isEmpty) return 0;
  final list_bc = rates.map((e) => e.binhChon);
  final sum_bc = list_bc.reduce((value, element) => value + element);

  return sum_bc / rates.length;
}
