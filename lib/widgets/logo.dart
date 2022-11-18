import 'package:flutter/cupertino.dart';
import 'package:resort/utils/constants.dart';

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
