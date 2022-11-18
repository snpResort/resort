import 'package:flutter/material.dart';

/// A button widget with rounded corner
class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback? onPressed;

  const RoundedButton(
      {Key? key, required this.color, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(title.toUpperCase()),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 5, vertical: 16),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
      ),
    );
  }
}
