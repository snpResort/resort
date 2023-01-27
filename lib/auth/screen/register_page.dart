import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/register_request.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/auth/screen/verify_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/constant/app_style.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/logo.dart';
import 'package:resort/widgets/message_alert.dart';
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
    final Widget logo = Hero(
      tag: 'logo',
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: const LogoApp(),
        ),
      ),
    );
    final Widget textFieldContent = Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 10),
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
              hintText: 'Mật khẩu',
              fillColor: Colors.white,
              filled: true,
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
              hintText: 'Xác nhật mật khẩu',
              fillColor: Colors.white,
              filled: true,
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
            messageAlert(
              context,
              'Vui lòng nhập email',
              color: Colors.yellow.shade700
            );
            return;
          } else if (_pw.text.isEmpty) {
            messageAlert(
              context,
              'Vui lòng nhập mật khẩu',
              color: Colors.yellow.shade700
            );
            return;
          } else if (_repw.text.isEmpty) {
            messageAlert(
              context,
              'Vui lòng nhập xác nhận mật khẩu',
              color: Colors.yellow.shade700
            );
            return;
          } else if (_pw.text != _repw.text) {
            messageAlert(
              context,
              'Xác nhận mật khẩu không chính xác',
              color: Colors.yellow.shade700
            );
            return;
          } else if (!EmailValidator.validate(_email.text)) {
            messageAlert(
              context,
              'Email không hợp lệ',
              color: Colors.yellow.shade700
            );
            _focusEmail.requestFocus();
            return;
          } 
          setState(() {
            _isLoading = true;
          });
          if (!await CheckUsername(username: _email.text)) {
            messageAlert(
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
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Đã có một tài khoản', style: TextStyle(color: Colors.white),),
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

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: _height / 8,),
                  logo,
                  textFieldContent,
                  registerButton,
                  const SizedBox(height: 10,),
                  RoundedButton(
                    color: Colors.grey.shade400,
                    title: 'Quay lại',
                    onPressed: () async {
                      Navigator.of(context).pop();
                    }
                  ),
                  bottomTextContent,
                ],
              ),
            ),
            if (_isLoading) 
            Container(
              height: _height,
              width: _width,
              color: Colors.black45,
              child: Center(
                child: LoadingWidget(),
              )
            )
          ]
        ),
      ),
    );
  }
}
