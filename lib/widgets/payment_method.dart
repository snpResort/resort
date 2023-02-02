import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resort/constant/app_colors.dart';
import 'package:resort/constant/app_numbers.dart';
import 'package:resort/widgets/rounded_button.dart';

enum PaymentMethodValue {
  payment1,
  payment2,
  payment3,
}

Future<void> paymentMethod(context, {Function(String)? onPress}) async {
  await Future.delayed(Duration(milliseconds: 0), () {
    if (true) {
      final _height = MediaQuery.of(context).size.height;
      final _width = MediaQuery.of(context).size.width;
      return showModalBottomSheet<int>(
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
                height: _height / 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Text(
                          'Chọn phương thức thanh toán', 
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(fontSize: _width / 14),)
                      ),
                      ListTile(
                        onTap: () {
                          if (onPress != null)
                            onPress('https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png');
                          Navigator.of(context).pop();
                        },
                        title: Text('MoMo'),
                        subtitle: CachedNetworkImage(imageUrl: 'https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png', height: 40, width: 40),
                      ),
                      ListTile(
                        title: Text('Zalo Pay'),
                        onTap: () {
                          if (onPress != null)
                            onPress('https://upload.wikimedia.org/wikipedia/vi/7/77/ZaloPay_Logo.png');
                          Navigator.of(context).pop();
                        },
                        subtitle: CachedNetworkImage(imageUrl: 'https://upload.wikimedia.org/wikipedia/vi/7/77/ZaloPay_Logo.png', height: 40, width: 40),
                      ),
                      ListTile(
                        title: Text('Thẻ ATM nội địa'),
                        onTap: () {
                          if (onPress != null)
                            onPress('atm');
                          Navigator.of(context).pop();
                        },
                        subtitle: CachedNetworkImage(imageUrl: 'https://cdn-icons-png.flaticon.com/512/8983/8983163.png', height: 40, width: 40),
                      )
                    ],
                  ),
                )
              );
        },
      );
    }
  });
}
