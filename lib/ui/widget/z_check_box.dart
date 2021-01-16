import 'package:flutter/material.dart';

/// @author zdl
/// date 2021/1/15 17:15
/// email zdl328465042@163.com
/// description 自定义样式的复选框
// ignore: must_be_immutable
class ZCheckBox extends StatefulWidget {
  bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String text;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Color bgColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;

  ZCheckBox({
    this.value = false,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onChanged,
    this.text,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
    this.bgColor,
    this.borderRadius,
    this.border,
  }) : assert(value != null);

  @override
  _ZCheckBoxState createState() => _ZCheckBoxState();
}

class _ZCheckBoxState extends State<ZCheckBox> {
  @override
  Widget build(BuildContext context) {
    var child;
    child = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: widget.borderRadius,
        border: widget.border,
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: widget.fontColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight
        ),
      ),
    );
    return InkWell(
      onTap: () {
        widget.value = !widget.value;
        if (widget.onChanged != null) widget.onChanged(widget.value);
        setState(() {});
      },
      child: child,
    );
  }
}
