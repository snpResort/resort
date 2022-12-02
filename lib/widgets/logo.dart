import 'package:flutter/cupertino.dart';
import 'package:resort/constant/app_string.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kLogoApp,
      fit: BoxFit.cover,
    );
  }
}
