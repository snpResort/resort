import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/login_request.dart';
import 'package:resort/auth/request/register_request.dart';
import 'package:resort/auth/screen/register_page.dart';
import 'package:resort/auth/screen/verify_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/constant/app_style.dart';
import 'package:resort/main.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/logo.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/rounded_button.dart';
import 'package:resort/widgets/wrong_alert.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    
    final Widget logo = Hero(
      tag: 'logo',
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
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
              hintText: 'Mật khẩu',
              fillColor: Colors.white,
              filled: true,
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
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  print('forget password');
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => ForgetPassword(),
                  );
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
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
          messageAlert(
            context,
            'Vui lòng nhập email',
            color: Colors.yellow.shade700
          );
          return;
        } else if (!EmailValidator.validate(_email.text)) {
          messageAlert(
            context,
            'Email không hợp lệ',
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
        }

        // Todo: check username & password (alert: thông tin đăng nhập không chính xác(err))
        loginRequest(username: _email.text, password: _pw.text).then((user) {
          if (user != null) {
            Provider.of<PUser>(context, listen: false).login(user);
            Navigator.of(context).pop();
          } else {
            setState(() {
              _isLoading = false;
            });
            messageAlert(
              context,
              'Thông tin đăng nhập không chính xác.\nVui lòng kiểm tra lại',
              color: Colors.yellow.shade700
            );
          }
        });

        setState(() {
          _isLoading = true;
        });
      },
    );

    // Register alternative option
    final Widget bottomTextContent = Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Không có tài khoản?', style: TextStyle(color: Colors.white),),
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
                  SizedBox(height: _height / 7,),
                  logo,
                  textFieldContent,
                  loginButton,
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
          ],
        )
      ),
    );
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  
  bool isLoad = false;
  TextEditingController _email = TextEditingController();
  
  final _focusEmail = FocusNode();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation!,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
                )
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 45,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          autofocus: true,
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: kEmailTextFieldDecoration(),
                          focusNode: _focusEmail,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isLoad ? Center(
                        child: LoadingWidget(color: Colors.orange),
                      ) 
                      : RoundedButton(
                        color: Colors.orange,
                        title: 'Tiếp tục',
                        onPressed: () async {
                          setState(() {
                            isLoad = true;
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
    
                          if (_email.text.isEmpty) {
                            messageAlert(
                              context,
                              'Vui lòng nhập email',
                              color: Colors.yellow.shade700
                            );
                            FocusScope.of(context).requestFocus(_focusEmail);
                            setState(() {
                              isLoad = false;
                            });
                          } else if (!EmailValidator.validate(_email.text)) {
                            messageAlert(
                              context,
                              'Email không hợp lệ',
                              color: Colors.yellow.shade700
                            );
                            FocusScope.of(context).requestFocus(_focusEmail);
                            setState(() {
                              isLoad = false;
                            });
                          } else {
                            final token = await SendVerifyCode(username: _email.text);
                            
                            Provider.of<PUser>(context, listen: false).setUser(User.login(username: _email.text, password: ''));
    
                            Provider.of<PUser>(context, listen: false).setToken(token);

                            Navigator.of(context).pop();
    
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VerifyPage(isforgotPassword: true),
                              )
                            ).then((value) {
                              setState(() {
                                isLoad = false;
                              });
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ]
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      icon: Icon(Icons.close, color: Colors.red)
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}