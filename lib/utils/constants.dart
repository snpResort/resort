import 'package:flutter/material.dart';

const kLogoApp = 'assets/images/logo.png';

const kUrlServer = '192.168.111.97:17051';

showSnackbar(context, String msg, {required int time}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: time * 1000),
      content: Text(msg),
    ),
  );
}

kEmailTextFieldDecoration() => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Email',
    prefixIcon: Icon(Icons.person));

kPasswordTextFieldDecoration() => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
    suffixIcon: Icon(Icons.remove_red_eye));
