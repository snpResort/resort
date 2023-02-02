import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resort/constant/app_colors.dart';
import 'package:resort/constant/app_numbers.dart';

Future<void> succesAlert(context, String a) async {
  await Future.delayed(Duration(milliseconds: 0), () {
    if (a != null || a.isNotEmpty) {
      return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(0),
            title: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppNumbers.buttonRadius),
                ),
                width: MediaQuery.of(context).size.width / 1.1,
                padding: EdgeInsets.only(right: 6, left: 8, bottom: 5, top: 25),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.check_mark,
                      size: 50,
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      a,
                      maxLines: 20,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text(
                              'OK',
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  });
}
