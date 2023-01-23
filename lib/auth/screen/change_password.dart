import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/change_password_request.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/logo.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/rounded_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  static String id = 'ChangePassword';

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  PUser? puser;

  var _obscureText1 = true;
  var _obscureText2 = true;
  
  var _pw1 = TextEditingController();
  var _pw2 = TextEditingController();
  
  var isLoad = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    puser = Provider.of<PUser>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final Widget logo = Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: const LogoApp(),
      ),
    );
    
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: _height / 7,),
                    logo,
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          TextField(
                            obscureText: _obscureText1,
                            controller: _pw1,
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu mới',
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
                          const SizedBox(height: 15,),
                          TextField(
                            obscureText: _obscureText2,
                            controller: _pw2,
                            decoration: InputDecoration(
                              hintText: 'Nhập lại mật khẩu mới',
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
                              if (_pw1.text.isEmpty) {
                                messageAlert(context, 'Vui lòng nhập mật khẩu cần đổi');
                              } else if (_pw2.text.isEmpty) {
                                messageAlert(
                                  context,
                                  'Vui lòng nhập xác nhận mật khẩu',
                                  color: Colors.yellow.shade700
                                );
                              } else if (_pw1.text != _pw2.text) {
                                messageAlert(
                                  context,
                                  'Xác nhận mật khẩu không chính xác',
                                  color: Colors.yellow.shade700
                                );
                              } else {
                                // todo: change password
                                final resultChangePassword = await changePassword(
                                  username: puser!.user!.username,
                                  password: _pw1.text
                                );
                                print('result changePassword api ${resultChangePassword.message}');
                                print('result changePassword error ${resultChangePassword.hasData}');
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
                  ],
                ),
              ),
            ),
            if (isLoad) 
            Container(
              height: _height,
              width: _width,
              color: Colors.black45,
              child: Center(
                child: LoadingWidget(),
              )
            )
          ],
        ),
      ),
    );
  }
}