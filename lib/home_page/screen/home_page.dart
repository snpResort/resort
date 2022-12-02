import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/widgets/custom_lp.dart';
import 'package:resort/widgets/gradient_mask.dart';
import 'package:resort/widgets/star_clipper.dart';

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

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final isLogin = Provider.of<PUser>(context).isLogin;
    final user = isLogin ? Provider.of<PUser>(context).user : null;

    return Stack(
      children: [
        CachedNetworkImage(
          fit: BoxFit.fill,
          height: _height,
          width: _width,
          imageUrl:
              'https://images.unsplash.com/photo-1540979388789-6cee28a1cdc9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTl8fHxlbnwwfHx8fA%3D%3D&w=1000&q=80',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
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
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (!Provider.of<PUser>(context, listen: true).isLogin)
                        IconButton(
                          onPressed: () {
                            PersistentNavBarNavigator
                                .pushNewScreenWithRouteSettings(
                              context,
                              screen: ScreenLogin(),
                              withNavBar: false,
                              settings: RouteSettings(name: ScreenLogin.id),
                            );
                          },
                          icon: Icon(
                            CupertinoIcons.person_crop_circle,
                            size: 30,
                            color: Colors.white,
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 30),
                  _carouseSlider(banners: banners),
                  const SizedBox(height: 25),
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
                              color: Colors.blue),
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
                      itemBuilder: (_, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: customLP_rate(
                                width: _width,
                                isHorizontal: true,
                                title: 'Standard',
                                price: '700,000',
                                amoutCmt: 100,
                                rateStar: '${5 - index}',
                                urlImage:
                                    'https://github.com/snpResort/images/blob/main/LoaiPhong/std2.jpg?raw=true',
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
                                          '${index + 1}',
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
                                          '${index + 1}',
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
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  _loaiPhong(width: _width),
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

class _loaiPhong extends StatelessWidget {
  const _loaiPhong({
    Key? key,
    required double width,
  })  : _width = width,
        super(key: key);

  final double _width;

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
                    color: Colors.blue),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Xem thêm',
                  style: TextStyle(
                    fontSize: _width / 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: 3,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: customLP(
                width: _width,
                isHorizontal: false,
                title: 'Standard',
                price: '700,000',
                amoutCmt: 100,
                rateStar: '3,5',
                urlImage:
                    'https://github.com/snpResort/images/blob/main/LoaiPhong/std2.jpg?raw=true',
              ),
            );
          },
        ),
      ],
    );
  }
}

class _carouseSlider extends StatelessWidget {
  const _carouseSlider({
    Key? key,
    required this.banners,
  }) : super(key: key);

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: banners.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 210,
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
    );
  }
}
