import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/model/room.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/home_page/request/room_request.dart';
import 'package:resort/home_page/screen/home_page.dart';
import 'package:resort/home_page/screen/room_info_page.dart';
import 'package:resort/widgets/custom_lp.dart';
import 'package:resort/widgets/loading_widget.dart';

class RoomsInfo extends StatefulWidget {
  RoomsInfo({super.key, this.rooms});
  List<Room>? rooms = [];
  static String id = 'RoomsInfo';
  @override
  State<RoomsInfo> createState() => _RoomsInfoState();
}

class _RoomsInfoState extends State<RoomsInfo> {
  List<Room> _rooms = [];
  bool isLoad = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rooms = widget.rooms ?? [];
    

    isLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Image.asset(
          kBg1,
          fit: BoxFit.fill,
          height: _height,
          width: _width,
        ),
        Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                CupertinoIcons.back,
                color: Colors.white,
              ),
            ),
            title: Text('Danh sách phòng'),
            centerTitle: true,
            elevation: 1,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () {
              setState(() {
                isLoad = true;
              });
              roomRequest().then((value) {
                print('==================== vale: $value');
                Provider.of<PRoom>(context, listen: false).setRooms(value??[]);
                setState(() {
                  isLoad = false;
                  try {
                    _rooms = value!;
                  } catch (e) {
                    print('------------e: $e');
                  }
                });
              });
              return Future.delayed(Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  children: [
                    _loaiPhong(
                      width: _width,
                      rooms: _rooms,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoad)
        Container(
          height: _height,
          width: _width,
          color: Colors.black45,
          child: Center(
            child: LoadingWidget(),
          ),
        )
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
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: rooms.length,
          physics: const NeverScrollableScrollPhysics(),
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
                ).then((value) {
                  if (value)
                  {
                    Navigator.of(context).pop();
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 18),
                child: customLP_info(
                  width: _width,
                  isHorizontal: false,
                  title: '${rooms[index].ten}',
                  price: '${rooms[index].gia}',
                  amoutCmt: sum_cmt(rooms[index].rates),
                  amountPeople: rooms[index].soNgLon + rooms[index].soTreEm,
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
