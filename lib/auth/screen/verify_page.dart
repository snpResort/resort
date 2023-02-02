import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/register_request.dart';
import 'package:resort/auth/screen/change_password.dart';
import 'package:resort/auth/screen/register_info.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/constant/app_style.dart';
import 'package:resort/widgets/logo.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/resend_code.dart';
import 'package:resort/widgets/wrong_alert.dart';

class VerifyPage extends StatefulWidget {
  bool isforgotPassword;

  VerifyPage({super.key, this.isforgotPassword = false});

  static String id = '/verifyCode';

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _focusVerifyCode = FocusNode();
  final _verifyCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final Widget logo = Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: const LogoApp(),
      ),
    );
    

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            kBg1,
            fit: BoxFit.fill,
            height: _height,
            width: _width,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: _height / 6,),
                  logo,
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: kVerifyTextFieldDecoration(),
                    controller: _verifyCode,
                    focusNode: _focusVerifyCode,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          print('comfirm code');
                          final token = Provider.of<PUser>(context, listen: false).token!;
                          final rs = await VerifyCode(token: token, code: _verifyCode.text);
            
                          try {
                            if (rs!['hasError']) {
                              messageAlert(context, rs['message'], color: Colors.yellow.shade700);
                              return;
                            }
            
                            Navigator.of(context)
                              .pushReplacementNamed(widget.isforgotPassword ? ChangePassword.id :  RegisterInfo.id);
                          } catch (e) {
                            print('-----------------------${e}');
                            messageAlert(
                              context, 
                              'Đã hết phiên xử lý.\nVui lòng gửi mã lại', 
                              color: Colors.yellow.shade700
                            );
                          }
                          _verifyCode.clear();
                        },
                        child: Text('Xác nhận', style: TextStyle(color: Colors.white),),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 15),
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.orange),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ButtonReSendCode(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3 / 3.3,
                        onTap: () async {
                          final token = await SendVerifyCode(
                            username: Provider.of<PUser>(context, listen: false)
                                .user!
                                .username,
                          );
            
                          Provider.of<PUser>(context, listen: false).setToken(token);
                        },
                        title: 'Gửi mã lại',
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
