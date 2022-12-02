import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/register_request.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/auth/screen/verify_page.dart';
import 'package:resort/constant/app_style.dart';
import 'package:resort/widgets/logo.dart';
import 'package:resort/widgets/rounded_button.dart';
import 'package:resort/widgets/wrong_alert.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  static String id = '/ScreenRegister';

  @override
  State<ScreenRegister> createState() => Screen_RegisterState();
}

class Screen_RegisterState extends State<ScreenRegister> {
  bool _obscureTextPw = true;
  bool _obscureTextRePw = true;
  final _email = TextEditingController();
  final _pw = TextEditingController();
  final _repw = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPw = FocusNode();
  final _focusRePw = FocusNode();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Widget logo = Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: const LogoApp(),
      ),
    );
    final Widget textFieldContent = Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: kEmailTextFieldDecoration(),
            controller: _email,
            focusNode: _focusEmail,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: _obscureTextPw,
            focusNode: _focusPw,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureTextPw ? Icons.visibility_off : Icons.visibility),
                onTap: () {
                  setState(() {
                    _obscureTextPw = !_obscureTextPw;
                  });
                },
              ),
            ),
            controller: _pw,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: _obscureTextRePw,
            focusNode: _focusRePw,
            decoration: InputDecoration(
              labelText: 'Xác nhật mật khẩu',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureTextRePw ? Icons.visibility_off : Icons.visibility),
                onTap: () {
                  setState(() {
                    _obscureTextRePw = !_obscureTextRePw;
                  });
                },
              ),
            ),
            controller: _repw,
          ),
        ],
      ),
    );
    // Login button
    final Widget registerButton = RoundedButton(
        color: Colors.orange,
        title: 'Đăng ký',
        onPressed: () async {
          Provider.of<PUser>(context, listen: false).clear();
          // Hide keyboard on login button press
          FocusManager.instance.primaryFocus?.unfocus();
          if (_email.text.isEmpty) {
            ackAlert(
              context,
              'Vui lòng nhập email',
            );
            return;
          } else if (!EmailValidator.validate(_email.text)) {
            ackAlert(
              context,
              'Email không hợp lệ',
            );
            _focusEmail.requestFocus();
            return;
          } else if (_pw.text.isEmpty) {
            ackAlert(
              context,
              'Vui lòng nhập mật khẩu',
            );
            return;
          } else if (_repw.text.isEmpty) {
            ackAlert(
              context,
              'Vui lòng nhập xác nhận mật khẩu',
            );
            return;
          } else if (_pw.text != _repw.text) {
            ackAlert(
              context,
              'Xác nhận mật khẩu không chính xác',
            );
            return;
          }
          setState(() {
            _isLoading = true;
          });
          if (!await CheckUsername(username: _email.text)) {
            ackAlert(
              context,
              'Email đã tồn tại',
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          Provider.of<PUser>(context, listen: false).setupUser(User.login(
            username: _email.text,
            password: _pw.text,
          ));

          final token = await SendVerifyCode(username: _email.text);

          Provider.of<PUser>(context, listen: false).setToken(token);

          Navigator.of(context).pushReplacementNamed(VerifyPage.id);
        });

    // Register alternative option
    final Widget bottomTextContent = Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Đã có một tài khoản'),
            const SizedBox(width: 4.0),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(ScreenLogin.id);
              },
              child: Text(
                'Đăng nhập',
                style: TextStyle(color: Colors.green),
              ),
            )
          ],
        ),
      ],
    );

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logo,
                textFieldContent,
                registerButton,
                bottomTextContent,
              ],
            ),
    );
  }
}
