import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget{
  LoadingWidget({super.key, Color color = Colors.white}): this.color = color;

  Color color;

  @override
  Widget build(BuildContext context) {
      return Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: SpinKitCircle(color: color),
        ),
      );
  }

}