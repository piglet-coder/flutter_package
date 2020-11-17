import 'package:flutter/material.dart';


/// @author zdl
/// date 2020/8/19 14:45
/// email zdl328465042@163.com
/// description 状态可变的Text
class ZTextVariable extends StatefulWidget {
  final String data;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;

  const ZTextVariable(
    this.data, {
    Key key,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  _ZTextVariableState createState() => _ZTextVariableState();
}

class _ZTextVariableState extends State<ZTextVariable> {
  String _txt;

  @override
  Widget build(BuildContext context) {
    return Text(
      _txt ?? widget.data,
      style: TextStyle(
        color: widget.fontColor,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
    );
  }

  void onChange(String value){
    setState(() {
      _txt = value;
    });
  }
}
