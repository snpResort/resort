import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:resort/widgets/rounded_button.dart';

class ChangePasswordUser extends StatefulWidget {
  const ChangePasswordUser({super.key});

  static String id = 'ChangePasswordUser';

  @override
  State<ChangePasswordUser> createState() => _ChangePasswordUserState();
}

class _ChangePasswordUserState extends State<ChangePasswordUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}