import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/register_request.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/wrong_alert.dart';

class RegisterInfo extends StatefulWidget {
  const RegisterInfo({super.key});

  static String id = '/RegisterInfo';

  @override
  State<RegisterInfo> createState() => _RegisterInfoState();
}

class _RegisterInfoState extends State<RegisterInfo> {
  TextEditingController _txtHoTen = TextEditingController();
  TextEditingController _txtNgaySinh = TextEditingController();
  TextEditingController _txtCCCD = TextEditingController();
  TextEditingController _txtSDT = TextEditingController();
  TextEditingController _txtDC = TextEditingController();

  GioiTinh? _gioiTinh = GioiTinh.Nam;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final _user = Provider.of<PUser>(context).user;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              kBg1,
              fit: BoxFit.fill,
              height: _height,
              width: _width,
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  width: _width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        'Thông tin cá nhân',
                        style: TextStyle(fontSize: _width / 12, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _txtHoTen,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Họ và tên',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(CupertinoIcons.pencil_outline),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1999, 1, 1),
                            maxTime: DateTime(2030, 12, 31),
                            onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              setState(() {
                                _txtNgaySinh.text = DateFormat('dd/MM/yyyy').format(date);
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.vi
                          );
                        },
                        controller: _txtNgaySinh,
                        readOnly: true,
                        inputFormatters: [
                          MaskTextInputFormatter(mask: "##/##/####"),
                        ],
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          hintText: 'Ngày sinh (31/12/2001)',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(CupertinoIcons.calendar),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _txtCCCD,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Căn cước công dân',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(CupertinoIcons.person_crop_rectangle_fill),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text('Giới tính: ',style: TextStyle(color: Colors.white),),
                          Expanded(
                            child: ListTile(
                              title: const Text('Nam', style: TextStyle(color: Colors.white),),
                              leading: Radio<GioiTinh>(
                                fillColor: MaterialStatePropertyAll(_gioiTinh == GioiTinh.Nam ? Colors.amber : Colors.white),
                                groupValue: _gioiTinh,
                                value: GioiTinh.Nam,
                                onChanged: (value) {
                                  setState(() {
                                    _gioiTinh = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Nữ', style: TextStyle(color: Colors.white),),
                              leading: Radio<GioiTinh>(
                                fillColor: MaterialStatePropertyAll(_gioiTinh == GioiTinh.Nu ? Colors.amber : Colors.white),
                                groupValue: _gioiTinh,
                                value: GioiTinh.Nu,
                                onChanged: (value) {
                                  setState(() {
                                    _gioiTinh = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _txtSDT,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskTextInputFormatter(mask: "#### ### ###"),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Số điện thoại',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(CupertinoIcons.phone),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _txtDC,
                        decoration: const InputDecoration(
                          hintText: 'Địa chỉ',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(CupertinoIcons.house_alt),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (_txtHoTen.text.trim() == '') {
                            messageAlert(
                              context,
                              'Vui lòng nhập họ tên',
                            );
                          } else if (_txtNgaySinh.text.trim() == '') {
                            messageAlert(
                              context,
                              'Vui lòng nhập ngày sinh',
                            );
                          } else if (_txtCCCD.text.trim() == '') {
                            messageAlert(
                              context,
                              'Vui lòng nhập căn cước công dân',
                            );
                          } else if (_txtSDT.text.trim() == '') {
                            messageAlert(
                              context,
                              'Vui lòng nhập số điện thoại',
                            );
                          } else if (!RegExp(
                                  r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$')
                              .hasMatch(_txtNgaySinh.text.trim())) {
                            messageAlert(
                              context,
                              'Ngày sinh không hợp lệ vui lòng nhập lại',
                            );
                          } else if (!RegExp(r'(09|01[2|6|8|9])+([0-9]{8})\b')
                              .hasMatch(_txtSDT.text.split(' ').join('').trim())) {
                            messageAlert(
                              context,
                              'Số điện thoại không hợp lệ vui lòng nhập lại',
                            );
                          } else {
                            _user!
                              ..hoTen = _txtHoTen.text
                              ..canCuoc = _txtCCCD.text
                              ..ngaySinh =
                                  DateFormat('dd/MM/yyyy').parse(_txtNgaySinh.text)
                              ..email = _user.username
                              ..diaChi = _txtDC.text
                              ..sdt = _txtSDT.text
                              ..gioiTinh = _gioiTinh == GioiTinh.Nam ? 'Nam' : 'Nữ';
      
                            final rs = await RegisterRequest(user: _user);

                            messageAlert(
                              context, 
                              rs.message!,
                              color: rs.hasError! ? null : Colors.blue.shade400,
                              onPressOK: rs.hasError! ? null : (){
                                Navigator.of(context).pushReplacementNamed(ScreenLogin.id);
                              }
                            );
                          }
    
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.orange,
                          ),
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: _width / 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum GioiTinh { Nam, Nu }
