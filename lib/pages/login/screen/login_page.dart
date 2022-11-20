import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:resort/pages/register/screen/register_page.dart';
import 'package:resort/utils/constants.dart';
import 'package:resort/widgets/logo.dart';
import 'package:resort/widgets/rounded_button.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  static String id = '/ScreenLogin';

  @override
  State<ScreenLogin> createState() => ScreenLoginState();
}

class ScreenLoginState extends State<ScreenLogin> {
  bool _obscureText = true;
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Widget logo = Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
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
            onChanged: (value) {
              _email = value;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            onChanged: (value) {
              _password = value;
            },
          ),
        ],
      ),
    );
    // Login button
    final Widget loginButton = RoundedButton(
        color: Colors.orange,
        title: 'Đăng nhập',
        onPressed: () async {
          // Hide keyboard on login button press
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _isLoading = true;
          });
        });

    // Register alternative option
    final Widget bottomTextContent = Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Không có tài khoản?'),
            const SizedBox(width: 4.0),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(ScreenRegister.id);
              },
              child: Text(
                'Đăng ký',
                style: TextStyle(color: Colors.green),
              ),
            )
          ],
        ),
      ],
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logo,
          textFieldContent,
          loginButton,
          bottomTextContent,
        ],
      ),
    );
  }
}
