import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/7/21 9:41
/// email zdl328465042@163.com
/// description 分割线
/// 若设置margin，则margin的间距会显示背景色，部分时候会导致线显示不准确，此时应设置bgColor
class ZLine extends StatelessWidget {
  final Color bgColor;
  final Color lineColor;
  final bool isHor;
  final double width;
  final double height;
  final EdgeInsets margin;

  const ZLine({
    this.bgColor,
    this.lineColor = const Color(0xffcccccc),
    this.isHor = true,
    this.width,
    this.height,
    this.margin,
  }) :
        //margin和bgColor必须同时存在
        assert(margin == null || bgColor != null,
            'ZLine，设置了margin，必须同时设置bgColor，以避免显示错误');

  @override
  Widget build(BuildContext context) {
    var line = Container(
      width: width ?? (isHor ? double.infinity : 1),
      height: height ?? (isHor ? 1 : double.infinity),
      margin: margin,
      color: lineColor,
    );
    Widget child;
    if (null != bgColor) {
      child = Container(
        color: bgColor,
        child: line,
      );
    } else {
      child = line;
    }
    return child;
  }
}
