import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/utils/constants.dart';
import 'package:resort/widgets/logo.dart';
import 'package:resort/widgets/rounded_button.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  static String id = '/ScreenRegister';

  @override
  State<ScreenRegister> createState() => Screen_RegisterState();
}

class Screen_RegisterState extends State<ScreenRegister> {
  @override
  Widget build(BuildContext context) {
    bool _obscureText = true;
    String _email = '';
    String _password = '';
    bool _isLoading = false;
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
          const SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Xác nhật mật khẩu',
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
        title: 'Đăng ký',
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
