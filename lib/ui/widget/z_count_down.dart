import 'dart:async';

import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/11/18 14:09
/// email zdl328465042@163.com
/// description 倒计时控件

typedef MeetCallback = bool Function();

class ZCountDown extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Decoration decoration;
  final int count;
  final String textStart;
  final String textEnd;
  final MeetCallback onTap;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final String format;

  const ZCountDown({
    this.width = 100,
    this.height = 20,
    this.padding,
    this.margin,
    this.decoration,
    this.count = 60,
    this.textStart = '获取验证码',
    this.textEnd = '重新获取',
    this.onTap,
    this.fontColor,
    this.fontSize = 14,
    this.fontWeight,
    this.format,
  }) : assert(count > 0);

  @override
  _ZCountDownState createState() => _ZCountDownState();
}

class _ZCountDownState extends State<ZCountDown> {
  Timer _timer;
  String _text;
  var _count;
  bool _ignoring = false;

  @override
  void initState() {
    super.initState();
    _text = widget.textStart;
    _count = widget.count;
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _ignoring,
      child: InkWell(
        onTap: () {
          if (widget.onTap != null && widget.onTap()) _startTimer();
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          decoration: widget.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey),
              ),
          alignment: Alignment.center,
          child: Text(
            _text,
            style: TextStyle(
              color: widget.fontColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _ignoring = true;
      _text = widget.format == null
          ? '$_count'
          : widget.format.replaceAll('%s', '$_count');
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_count == 0) {
          _count = widget.count;
          _text = widget.textEnd;
          _timer.cancel();
          _ignoring = false;
        } else {
          _text = widget.format == null
              ? '${--_count}'
              : widget.format.replaceAll('%s', '${--_count}');
        }
      });
    });
  }
}
