import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/change_password_request.dart';
import 'package:resort/auth/request/login_request.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/rounded_button.dart';

class ChangePasswordUser extends StatefulWidget {
  const ChangePasswordUser({super.key});

  static String id = 'ChangePasswordUser';

  @override
  State<ChangePasswordUser> createState() => _ChangePasswordUserState();
}

class _ChangePasswordUserState extends State<ChangePasswordUser> {
  bool isLoad = false;
  
  var _obscureText1 = true;
  var _obscureText2 = true;
  var _obscureText3 = true;
  
  var _pwCurrent = TextEditingController();
  
  var _pw1 = TextEditingController();
  var _pw2 = TextEditingController();

  PUser? puser;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    puser = Provider.of<PUser>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              'Thay đổi mật khẩu',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    obscureText: _obscureText1,
                    controller: _pwCurrent,
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu hiện tại',
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child: Icon(
                            _obscureText1 ? Icons.visibility_off : Icons.visibility),
                        onTap: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    obscureText: _obscureText2,
                    controller: _pw1,
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu mới',
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child: Icon(
                            _obscureText2 ? Icons.visibility_off : Icons.visibility),
                        onTap: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    obscureText: _obscureText3,
                    controller: _pw2,
                    decoration: InputDecoration(
                      hintText: 'Nhập lại mật khẩu mới',
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child: Icon(
                            _obscureText3 ? Icons.visibility_off : Icons.visibility),
                        onTap: () {
                          setState(() {
                            _obscureText3 = !_obscureText3;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                RoundedButton(
                  color: Colors.orange, 
                  title: 'Xác nhận',
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      isLoad = true;
                    });
                    // todo: check validate
                    if (_pwCurrent.text.isEmpty) {
                      messageAlert(context, 'Vui lòng nhập mật khẩu hiện tại');
                    } else if (_pw1.text.isEmpty) {
                      messageAlert(
                        context,
                        'Vui lòng nhập mật khẩu mới',
                      );
                    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$\b').hasMatch(_pw1.text)) {
                      messageAlert(
                        context,
                        'Mật khẩu phải tối thiểu tám ký tự, ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt',
                        color: Colors.yellow.shade700
                      );
                      return;
                    } else if (_pw2.text.isEmpty) {
                      messageAlert(
                        context,
                        'Vui lòng nhập lại mật khẩu mới',
                      );
                    } else if (_pwCurrent.text != puser!.user!.password) {
                      messageAlert(
                        context,
                        'Mật khẩu hiện tại không chính xác.\nVui lòng kiểm tra lại',
                      );
                    } else if (_pw1.text != _pw2.text) {
                      messageAlert(
                        context,
                        'Xác nhận mật khẩu không chính xác',
                      );
                    } else {
                      // todo: change password
                      final resultChangePassword = await changePassword(
                        username: puser!.user!.username,
                        password: _pw1.text
                      );
                      print('result changePassword api ${resultChangePassword.message}');
                      print('result changePassword error ${resultChangePassword.hasData}');
                      if (!resultChangePassword.hasError!) {
                        final reloadUser = await loginRequest(username: puser!.user!.username, password: _pw1.text);
                        if (reloadUser != null) {
                          Provider.of<PUser>(context, listen: false).login(reloadUser);
                        }
                      }
                      messageAlert(
                        context, resultChangePassword.message!, 
                        color: resultChangePassword.hasError! ? null : Colors.blue.shade300);

                      Navigator.of(context).pop();
                    }
                    setState(() {
                      isLoad = false;
                    });
                  },
                )
              ],
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
    );
  }
}