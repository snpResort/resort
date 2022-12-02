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

    final _user = Provider.of<PUser>(context).user;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: _width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Thông tin cá nhân',
                  style: TextStyle(fontSize: _width / 12),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _txtHoTen,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(CupertinoIcons.pencil_outline),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _txtNgaySinh,
                  inputFormatters: [
                    MaskTextInputFormatter(mask: "##/##/####"),
                  ],
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh (31/12/2001)',
                    border: const OutlineInputBorder(),
                    prefixIcon: GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1999, 1, 1),
                              maxTime: DateTime(2030, 12, 31),
                              onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            setState(() {
                              _txtNgaySinh.text =
                                  DateFormat('dd/MM/yyyy').format(date);
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.vi);
                        },
                        child: const Icon(CupertinoIcons.calendar)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _txtCCCD,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Căn cước công dân',
                    border: const OutlineInputBorder(),
                    prefixIcon:
                        const Icon(CupertinoIcons.person_crop_rectangle_fill),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text('Giới tính: '),
                    Expanded(
                      child: ListTile(
                        title: Text('Nam'),
                        leading: Radio<GioiTinh>(
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
                        title: Text('Nữ'),
                        leading: Radio<GioiTinh>(
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
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(CupertinoIcons.phone),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _txtDC,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(CupertinoIcons.house_alt),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (_txtHoTen.text.trim() == '') {
                      ackAlert(
                        context,
                        'Vui lòng nhập họ tên',
                      );
                      return;
                    }
                    if (_txtNgaySinh.text.trim() == '') {
                      ackAlert(
                        context,
                        'Vui lòng nhập ngày sinh',
                      );
                      return;
                    } else if (!RegExp(
                            r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$')
                        .hasMatch(_txtNgaySinh.text.trim())) {
                      ackAlert(
                        context,
                        'Ngày sinh không hợp lệ vui lòng nhập lại',
                      );
                      return;
                    }

                    if (_txtCCCD.text.trim() == '') {
                      ackAlert(
                        context,
                        'Vui lòng nhập căn cước công dân',
                      );
                      return;
                    }
                    if (_txtSDT.text.trim() == '') {
                      ackAlert(
                        context,
                        'Vui lòng nhập số điện thoại',
                      );
                      return;
                    } else if (!RegExp(r'(09|01[2|6|8|9])+([0-9]{8})\b')
                        .hasMatch(_txtSDT.text.split(' ').join('').trim())) {
                      ackAlert(
                        context,
                        'Số điện thoại không hợp lệ vui lòng nhập lại',
                      );
                      return;
                    }

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

                    Navigator.of(context).pushReplacementNamed(ScreenLogin.id);
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
      ),
    );
  }
}

enum GioiTinh { Nam, Nu }
