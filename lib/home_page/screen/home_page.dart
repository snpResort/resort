import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/model/rate.dart';
import 'package:resort/home_page/model/room.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/home_page/request/room_request.dart';
import 'package:resort/home_page/screen/room_info_page.dart';
import 'package:resort/widgets/carouse_slider.dart';
import 'package:resort/widgets/custom_lp.dart';
import 'package:resort/widgets/gradient_mask.dart';
import 'package:resort/widgets/star_clipper.dart';

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
  List<Room> rooms = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    roomRequest().then((value) {
      setState(() {
        isLoad = false;
        rooms = value!;
      });
    });

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
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              IconButton(
                                onPressed: () {
                                  PersistentNavBarNavigator
                                      .pushNewScreenWithRouteSettings(
                                    context,
                                    screen: ScreenLogin(),
                                    withNavBar: false,
                                    settings:
                                        RouteSettings(name: ScreenLogin.id),
                                  );
                                },
                                icon: Icon(
                                  CupertinoIcons.person_crop_circle,
                                  size: 40,
                                  color: Colors.white,
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
                          width: _width / 1.2,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Giá',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.search),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: .6),
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
                                                'Từ ngày',
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
                                                'Đến ngày',
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
                                          '1 người, 1 phòng',
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Provider.of<PRoom>(context, listen: false)
                                      .setRoom(favRoom.elementAt(index));
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const RoomInfoPage(),
                                    withNavBar:
                                        true, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
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
      ],
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
                onTap: () {},
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
                  screen: const RoomInfoPage(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
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
