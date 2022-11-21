import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/widgets/gradient_mask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String id = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/banner4.jpg',
    'assets/images/banner5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 35,
          width: MediaQuery.of(context).size.width / 1.15,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 3),
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.search,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onChanged: (val) {},
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration.collapsed(
                      hintText: "Search...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ),
              Container(
                color: Colors.black,
                width: 1.2,
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {},
                child: RadiantGradientMask(
                  child: Icon(CupertinoIcons.circle_grid_hex),
                  gradient: [
                    Colors.deepOrange,
                    Colors.orangeAccent.shade200,
                    Colors.yellow,
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (!Provider.of<PUser>(context, listen: true).isLogin)
            IconButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  screen: ScreenLogin(),
                  withNavBar: false,
                  settings: RouteSettings(name: ScreenLogin.id),
                );
              },
              icon: Icon(
                CupertinoIcons.person_crop_circle,
                size: 30,
                color: Colors.black,
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            CarouselSlider(
              items: banners.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(i),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 300,
                aspectRatio: 16 / 9,
                viewportFraction: .7,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {},
                scrollDirection: Axis.horizontal,
                pauseAutoPlayInFiniteScroll: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
