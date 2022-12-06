import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resort/widgets/gradient_mask.dart';

class customLP extends StatelessWidget {
  customLP(
      {Key? key,
      required double width,
      required this.title,
      required this.price,
      required this.urlImage,
      required this.amoutCmt,
      required this.rateStar,
      required this.isHorizontal})
      : _width = width,
        super(key: key);

  final double _width;
  final String title;
  final String price;
  final String urlImage;
  final int amoutCmt;
  final String rateStar;
  final bool isHorizontal;

  final oCcy = new NumberFormat("#,##0");

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: _width,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(urlImage),
            ),
          ),
        ),
        Container(
          width: _width,
          height: isHorizontal ? 70 : null,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: _width / 1.95,
                    child: Text(
                      '$title',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _width / 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${oCcy.format(double.parse(price))} ₫',
                        style: TextStyle(
                          fontSize: _width / 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '/đêm',
                        style: TextStyle(
                          fontSize: _width / 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  RadiantGradientMask(
                    child: Icon(
                      CupertinoIcons.chat_bubble_text,
                      size: _width / 18,
                    ),
                    gradient: [
                      Colors.deepOrange,
                      Colors.yellow.shade400,
                      Colors.white,
                    ],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${amoutCmt}',
                    style: TextStyle(
                      fontSize: _width / 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    rateStar,
                    style: TextStyle(
                      fontSize: _width / 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 5),
                  RadiantGradientMask(
                    child: Icon(
                      CupertinoIcons.star_fill,
                      size: _width / 18,
                    ),
                    gradient: [
                      Colors.deepOrange,
                      Colors.orange.shade500,
                      Colors.orange.shade200,
                      Colors.yellow,
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class customLP_rate extends StatelessWidget {
  customLP_rate(
      {Key? key,
      required double width,
      required this.title,
      required this.price,
      required this.urlImage,
      required this.amoutCmt,
      required this.rateStar,
      required this.isHorizontal})
      : _width = width,
        super(key: key);

  final oCcy = new NumberFormat("#,##0");

  final double _width;
  final String title;
  final String price;
  final String urlImage;
  final int amoutCmt;
  final String rateStar;
  final bool isHorizontal;

  final _scale16_9 = 1.78;
  final _height = 155.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: _height * _scale16_9,
          height: _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(urlImage),
            ),
          ),
        ),
        Container(
          width: _height * _scale16_9,
          height: isHorizontal ? _height / 2.7 : null,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: _width / 2.8,
                    child: Text(
                      '$title',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _width / 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${oCcy.format(double.parse(price))} ₫',
                        style: TextStyle(
                          fontSize: _height * _scale16_9 / 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '/đêm',
                        style: TextStyle(
                          fontSize: _height * _scale16_9 / 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  RadiantGradientMask(
                    child: Icon(
                      CupertinoIcons.chat_bubble_text,
                      size: _height * _scale16_9 / 18,
                    ),
                    gradient: [
                      Colors.deepOrange,
                      Colors.yellow.shade400,
                      Colors.white,
                    ],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${amoutCmt}',
                    style: TextStyle(
                      fontSize: _height * _scale16_9 / 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    rateStar,
                    style: TextStyle(
                      fontSize: _height * _scale16_9 / 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 5),
                  RadiantGradientMask(
                    child: Icon(
                      CupertinoIcons.star_fill,
                      size: _height * _scale16_9 / 18,
                    ),
                    gradient: [
                      Colors.deepOrange,
                      Colors.orange.shade500,
                      Colors.orange.shade200,
                      Colors.yellow,
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
