import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:resort/main.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});
  static String id = 'UserInfoPage';
  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black26,
        centerTitle: true,
        title: Text(
          'Thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            DataTableCustom(flex: 2, {
              'Họ tên': 'Từ Huệ Sơn',
              'Email': 'tuhueson@gmail.com',
              'Căn căn công dân': '079201014714',
              'Số điện thoại': '0938252793',
              'Mã thành viên': '2225555',
            }),
          ],
        ),
      ),
    );
  }
}

class DataTableCustom extends StatelessWidget {
  DataTableCustom(
    this.data, {
    Key? key,
    this.flex = 1,
  }) : super(key: key);

  final Map<String, String> data;
  int flex;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration:
      //     BoxDecoration(border: Border.all(width: .5, color: Colors.grey)),
      child: Column(
        children: data.keys.map((e) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: flex,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(e),
                    ),
                  ),
                  Expanded(
                    flex: flex + 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Text(data[e]!),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // const Divider(
              //   height: 0,
              // ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
