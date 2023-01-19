import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CountInfo extends StatefulWidget {
  CountInfo({super.key, required this.soLuongTreEm, required this.soluongNguoiLon, required this.soLuongPhong});

  int soLuongTreEm, soluongNguoiLon, soLuongPhong;

  @override
  State<CountInfo> createState() => _CountInfoState();
}

class _CountInfoState extends State<CountInfo> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số lượng người lớn:',
                style: TextStyle(
                  fontSize: _width / 18,
                ),
              ),
              const SizedBox(width: 25),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soluongNguoiLon > 1) {
                            widget.soluongNguoiLon--;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      child: Text(
                        '${widget.soluongNguoiLon}',
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soluongNguoiLon < 10) {
                            widget.soluongNguoiLon++;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(50)),
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số lượng trẻ em:',
                style: TextStyle(
                  fontSize: _width / 18,
                ),
              ),
              const SizedBox(width: 25),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soLuongTreEm > 0) {
                            widget.soLuongTreEm--;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      child: Text(
                        '${widget.soLuongTreEm}',
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soLuongTreEm < 10) {
                            widget.soLuongTreEm++;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(50)),
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số lượng phòng:',
                style: TextStyle(
                  fontSize: _width / 18,
                ),
              ),
              const SizedBox(width: 25),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.soLuongPhong > 1) {
                            widget.soLuongPhong--;
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(50),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      child: Text(
                        '${widget.soLuongPhong}',
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                            widget.soLuongPhong++;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(50)),
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop<Map<String, int>>(
                {
                  "soLuongTreEm": widget.soLuongTreEm,
                  "soluongNguoiLon": widget.soluongNguoiLon,
                  "soLuongPhong": widget.soLuongPhong
                }
              );
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
                'Xác nhận',
                style: TextStyle(color: Colors.white, fontSize: _width / 18),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}