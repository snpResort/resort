import 'package:flutter/material.dart';

kEmailTextFieldDecoration() => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Email',
    prefixIcon: Icon(Icons.person));

kVerifyTextFieldDecoration() => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Code',
    prefixIcon: Icon(Icons.numbers));

kPasswordTextFieldDecoration() => const InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
    suffixIcon: Icon(Icons.remove_red_eye));
