import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/main.dart';
import 'package:resort/user_page/screen/edit_info_page.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});
  static String id = 'UserInfoPage';
  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  User? user;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    user = Provider.of<PUser>(context).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditInfoPage(user: user,),)
              );
            }, 
            icon: Icon(Icons.edit, color: Colors.black,)
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 10),
            DataTableCustom(flex: 3, {
              'Họ tên': '${user!.hoTen}',
              'Giới tính': '${user!.gioiTinh}',
              'Email': '${user!.email}',
              'Ngày sinh': '${DateFormat('dd/MM/yyyy').format(user!.ngaySinh)}',
              'Căn căn công dân': '${user!.canCuoc}',
              'Số điện thoại': '${formatPhoneNumber(user!.sdt)}',
              'Địa chỉ': '${user!.diaChi}',
              'Mã thành viên': '${user!.idTK}',
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
    final _width = MediaQuery.of(context).size.width;
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
                      child: Text(
                        e,
                        style: TextStyle(fontSize: _width / 22),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: flex + 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            data[e]!,
                            style: TextStyle(fontSize: _width / 22),
                          ),
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

formatPhoneNumberBasic(phone_number) {
  return phone_number.split(' ').join('');
}
formatPhoneNumber(phone_number) {
  return phone_number.replaceAllMapped(RegExp(r'(\d{4})(\d{3})(\d+)'), (Match m) => "${m[1]} ${m[2]} ${m[3]}");
}