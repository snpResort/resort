import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/register_request.dart';
import 'package:resort/auth/screen/register_info.dart';
import 'package:resort/constant/app_style.dart';
import 'package:resort/widgets/resend_code.dart';
import 'package:resort/widgets/wrong_alert.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  static String id = '/verifyCode';

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _focusVerifyCode = FocusNode();
  final _verifyCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    final token =
                        Provider.of<PUser>(context, listen: false).token!;
                    final rs =
                        await VerifyCode(token: token, code: _verifyCode.text);

                    try {
                      if (rs!['hasError']) {
                        ackAlert(context, rs['message']);
                        return;
                      }

                      Navigator.of(context)
                          .pushReplacementNamed(RegisterInfo.id);
                    } catch (e) {
                      print('-----------------------${e}');
                      ackAlert(
                          context, 'Đã hết phiên xử lý.\nVui lòng gửi mã lại');
                    }
                  },
                  child: Text('Xác nhận'),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 15),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                ),
                const SizedBox(height: 20),
                ButtonReSendCode(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: MediaQuery.of(context).size.width / 2.5 / 3.3,
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
    );
  }
}
