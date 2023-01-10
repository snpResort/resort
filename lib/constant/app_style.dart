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

kCMTTextFieldDecoration() =>  InputDecoration(
  contentPadding: EdgeInsets.only(bottom: 150, left: 10, top: 10, right: 10),
  isDense: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.black, width: 0.5),
    borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.black, width: 0.5),
    borderRadius: BorderRadius.circular(10)),
  labelText: 'Bình luận',
);