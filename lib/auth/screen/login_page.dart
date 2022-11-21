import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/register_page.dart';
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
  bool _isLoading = false;
  final _email = TextEditingController();
  final _pw = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPw = FocusNode();

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
            controller: _email,
            focusNode: _focusEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: kEmailTextFieldDecoration(),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            obscureText: _obscureText,
            controller: _pw,
            focusNode: _focusPw,
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
          if (_email.text.isEmpty) {
            showSnackbar(context, 'Vui lòng nhập email', time: 2);
            _focusEmail.requestFocus();
          } else if (_pw.text.isEmpty) {
            showSnackbar(context, 'Vui lòng nhập mật khẩu', time: 2);
            _focusPw.requestFocus();
          }

          // Todo: login thành công
          User user = User(username: _email.text, password: _pw.text);
          Provider.of<PUser>(context, listen: false).login(user);
          setState(() {
            _isLoading = true;
          });
          Navigator.of(context).pop();
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
