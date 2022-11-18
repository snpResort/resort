import 'package:flutter/material.dart';

const kLogoApp = 'assets/images/logo.png';

kEmailTextFieldDecoration() => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Email',
    prefixIcon: Icon(Icons.person));

kPasswordTextFieldDecoration() => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
    suffixIcon: Icon(Icons.remove_red_eye));
