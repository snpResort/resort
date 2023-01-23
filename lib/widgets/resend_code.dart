import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonReSendCode extends StatefulWidget {
  ButtonReSendCode({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.onTap,
  });
  double width;
  double height;
  Function onTap;
  String title;

  @override
  State<ButtonReSendCode> createState() => _ButtonReSendCodeState();
}

class _ButtonReSendCodeState extends State<ButtonReSendCode> {
  int _number_timecountdown = 60;
  late Timer _timer;
  late bool _isTimeout;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    _isTimeout = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: !_isTimeout ? Colors.grey : Colors.amber,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${widget.title} ${_number_timecountdown == 0 ? '' : '($_number_timecountdown)'}'
                  .trim(),
              style: TextStyle(
                color: !_isTimeout ? Colors.white54 : Colors.black,
                fontSize: widget.width / 7,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        onPressed: () {
          if (_number_timecountdown == 0) {
            widget.onTap();

            setState(() {
              _number_timecountdown = 60;
              _isTimeout = !_isTimeout;
              startTimer();
            });
          }
        },
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _number_timecountdown--;
          if (_number_timecountdown == 0) {
            timer.cancel();
            _isTimeout = !_isTimeout;
          }
        });
      },
    );
  }
}
