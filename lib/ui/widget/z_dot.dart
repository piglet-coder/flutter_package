import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/11/10 16:14
/// email zdl328465042@163.com
/// description 圆点、圆圈
class ZDot extends StatelessWidget {
  final double radius;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool isOutline;
  final double outlineWidth;
  final Widget child;

  const ZDot({
    @required this.radius,
    @required this.color,
    this.padding,
    this.margin,
    this.isOutline = false,
    this.outlineWidth = 1,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(radius / 2),
        border:
        isOutline ? Border.all(color: color, width: outlineWidth) : null,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
