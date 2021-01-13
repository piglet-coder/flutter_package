import 'package:flutter/material.dart';
import '../../extension/extension_num.dart';

/// @author zdl
/// date 2020/7/21 9:41
/// email zdl328465042@163.com
/// description 分割线
class ZLine extends StatelessWidget {
  final Color lineColor;
  final bool isHor;
  final double width;
  final double height;
  final EdgeInsets margin;

  const ZLine({
    this.lineColor = const Color(0xffcccccc),
    this.isHor = true,
    this.width,
    this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    var line = Container(
      width: width ?? (isHor ? double.infinity : 1.toFit()),
      height: height ?? (isHor ? 1.toFit() : double.infinity),
      margin: margin,
      color: lineColor,
    );
    if (margin != null) {
      line = Container(
        color: Colors.transparent,
        child: line,
      );
    }
    return line;
  }
}
