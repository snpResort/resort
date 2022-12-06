import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/explore_page/request/service_request.dart';
import 'package:resort/widgets/carouse_slider.dart';

import 'package:resort/explore_page/model/service.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  static String id = '/explore';

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> banners = [
    'https://snpresort.github.io/images/panel/panel1.jpg',
    'https://snpresort.github.io/images/panel/panel2.jpg',
    'https://snpresort.github.io/images/panel/panel3.jpg',
    'https://snpresort.github.io/images/panel/panel4.jpg',
    'https://snpresort.github.io/images/panel/panel5.jpg',
  ];
  bool _isLoad = false;
  late List<Service> _services = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceRequest().then(
      (value) {
        print(value);
        setState(() {
          _services = value!;
        });
      },
    );
    serviceImageRequest().then((value) {
      setState(() {
        _isLoad = false;
        banners = value!;
      });
    });
    _isLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Image.asset(
          kBg2,
          fit: BoxFit.fill,
          height: _height,
          width: _width,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _isLoad
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        CarouseSlider(banners: banners),
                        Container(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _services.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 40),
                                    Text(
                                      '- ${_services[index].tenDV} -',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: _width / 10,
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    CachedNetworkImage(
                                      imageUrl: '${_services[index].images[0]}',
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        '${_services[index].moTa}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: _width / 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 65),
                      ],
                    ),
                  ),
                ),
        )
      ],
    );
  }
}
