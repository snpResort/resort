import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:resort/utils/constants.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static String id = '/CartPage';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _cartIsEmpty = true;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 6),
          Text(
            'Giỏ hàng',
            style: TextStyle(fontSize: _width / 16),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _cartIsEmpty
                      ? Image.asset(
                          kCartEmpty,
                          height: MediaQuery.of(context).size.height / 1.5,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          const Divider(
            height: 10,
            thickness: 5,
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng cộng',
                        style: TextStyle(
                          fontSize: _width / 19,
                        ),
                      ),
                      Text(
                        '0₫',
                        style: TextStyle(
                          fontSize: _width / 19,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: _width / 4,
                          vertical: 13,
                        ),
                      ),
                    ),
                    child: Text(
                      'Thanh toán',
                      style:
                          TextStyle(color: Colors.white, fontSize: _width / 18),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}