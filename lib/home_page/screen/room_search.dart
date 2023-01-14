import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/home_page/model/room.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/home_page/screen/home_page.dart';
import 'package:resort/home_page/screen/room_info_page.dart';
import 'package:resort/widgets/custom_lp.dart';

class RoomSearch extends StatefulWidget {
  RoomSearch({super.key, this.listSearchRoom});
  static String id = 'RoomSearch';

  List<Room>? listSearchRoom;

  @override
  State<RoomSearch> createState() => _RoomSearchState();
}

class _RoomSearchState extends State<RoomSearch> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Stack(
        children: [
          Image.asset(
            kBg1,
            fit: BoxFit.fill,
            height: _height,
            width: _width,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Danh sách phòng',
                      style: TextStyle(fontSize: _width/15, color: Colors.white),
                    ),
                  ),
                  _loaiPhong(
                    width: _width,
                    rooms: widget.listSearchRoom!,
                  ),
                  const SizedBox(height: 60),
                ],
              ),
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
                  screen: const RoomInfoPage(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
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