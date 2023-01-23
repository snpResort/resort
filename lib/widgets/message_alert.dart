import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resort/constant/app_colors.dart';
import 'package:resort/constant/app_numbers.dart';

Future<void> messageAlert(context, String a, {Color? color, Function? onPressOK, Function? onPressCancel }) async {
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
                padding: EdgeInsets.only(right: 6, left: 8, bottom: 0, top: 25),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.info,
                      size: 50,
                      color: color ?? Colors.yellow.shade700,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Thông báo'),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      a,
                      maxLines: 20,
                      style: TextStyle(fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text(
                              'OK',
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (onPressOK != null) {
                                onPressOK();
                              }
                            },
                          ),
                        ),
                        if (onPressCancel != null)
                        Expanded(
                          child: TextButton(
                            child: Text(
                              'Trở lại',
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onPressCancel();
                            },
                          ),
                        ),
                      ],
                    ),
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
