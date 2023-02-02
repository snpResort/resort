import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/login_request.dart';
import 'package:resort/auth/request/register_request.dart';
import 'package:resort/auth/screen/register_info.dart';
import 'package:resort/user_page/screen/user_info_page.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/rounded_button.dart';

class EditInfoPage extends StatefulWidget {
  EditInfoPage({super.key, this.user});

  User? user;

  static String id = 'EditInfoPage';

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  TextEditingController _txtHoTen = TextEditingController();
  TextEditingController _txtNgaySinh = TextEditingController();
  TextEditingController _txtCCCD = TextEditingController();
  TextEditingController _txtSDT = TextEditingController();
  TextEditingController _txtDC = TextEditingController();

  bool isLoad = false;
  
  GioiTinh _gioiTinh = GioiTinh.Nam;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _txtHoTen.text = widget.user!.hoTen;
    _txtNgaySinh.text = DateFormat('dd/MM/yyyy').format(widget.user!.ngaySinh);
    _txtCCCD.text = widget.user!.canCuoc;
    _txtSDT.text = formatPhoneNumber(widget.user!.sdt);
    _txtDC.text = widget.user!.diaChi;
    _gioiTinh = widget.user!.gioiTinh == 'Nam' ? GioiTinh.Nam : GioiTinh.Nu;
  }
  
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
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
                'Chỉnh sửa thông tin',
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
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
                      onTap: null,
                      readOnly: false,
                      controller: _txtNgaySinh,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: "##/##/####"),
                      ],
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'Ngày sinh (31/12/2001)',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        prefixIcon: GestureDetector(
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
                          child: Icon(CupertinoIcons.calendar)
                        ),
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
                        const Text('Giới tính: ',style: TextStyle(color: Colors.black),),
                        Expanded(
                          child: ListTile(
                            title: const Text('Nam', style: TextStyle(color: Colors.black),),
                            leading: Radio<GioiTinh>(
                              fillColor: MaterialStatePropertyAll(_gioiTinh == GioiTinh.Nam ? Colors.amber : Colors.grey.shade400),
                              groupValue: _gioiTinh,
                              value: GioiTinh.Nam,
                              onChanged: (value) {
                                setState(() {
                                  _gioiTinh = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Nữ', style: TextStyle(color: Colors.black),),
                            leading: Radio<GioiTinh>(
                              fillColor: MaterialStatePropertyAll(_gioiTinh == GioiTinh.Nu ? Colors.amber : Colors.grey.shade400),
                              groupValue: _gioiTinh,
                              value: GioiTinh.Nu,
                              onChanged: (value) {
                                setState(() {
                                  _gioiTinh = value!;
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
                    const SizedBox(height: 15,),
                    RoundedButton(
                      color: Colors.orange, 
                      title: 'Xác nhận',
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        // todo: check validate
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
                        } else if (!RegExp(r'(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})\b')
                            .hasMatch(_txtSDT.text.split(' ').join('').trim())) {
                          messageAlert(
                            context,
                            'Số điện thoại không hợp lệ vui lòng nhập lại',
                          );
                        } else {
                          setState(() {
                            isLoad = true;
                          });

                          widget.user!
                            ..hoTen = _txtHoTen.text
                            ..canCuoc = _txtCCCD.text
                            ..ngaySinh = DateFormat('dd/MM/yyyy').parse(_txtNgaySinh.text)
                            ..diaChi = _txtDC.text
                            ..sdt = _txtSDT.text.split(' ').join('').trim()
                            ..gioiTinh = _gioiTinh == GioiTinh.Nam ? 'Nam' : 'Nữ';

                          final rs = await EditInfoUser(user: widget.user!);

                          if (rs.hasError!) {
                            messageAlert(context, 'Đã xảy ra lỗi\nVui lòng thử lại');
                          } else {
                            final reloadUser = await loginRequest(username: widget.user!.username, password: widget.user!.password);
                            if (reloadUser != null) {
                              Provider.of<PUser>(context, listen: false).login(reloadUser);
                            }

                            messageAlert(
                              context, 
                              rs.message!,
                              color: rs.hasError! ? null : Colors.blue.shade400,
                              onPressOK: rs.hasError! ? null : () {
                                Navigator.of(context).pop();
                              }
                            );
                          }

                          setState(() {
                            isLoad = false;
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          if (isLoad)
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
            child: Center(child: LoadingWidget()),
          )
        ],
      ),
    );
  }
}