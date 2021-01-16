import 'package:flutter/material.dart';

/// @author zdl
/// date 2021/1/15 17:15
/// email zdl328465042@163.com
/// description 自定义样式的复选框
// ignore: must_be_immutable
class ZCheckBox extends StatefulWidget {
  bool value;
  final dynamic tag;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String text;
  final TextStyle checkedStyle;
  final Decoration checkedDecoration;
  final TextStyle uncheckedStyle;
  final Decoration uncheckedDecoration;

  ZCheckBox({
    this.value = false,
    this.tag,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onChanged,
    this.text,
    this.checkedStyle,
    this.checkedDecoration,
    this.uncheckedStyle,
    this.uncheckedDecoration,
  }) : assert(value != null);

  _ZCheckBoxState _state;

  @override
  _ZCheckBoxState createState(){
    _state = _ZCheckBoxState();
    return _state;
  }

  void notify() => _state.notify();
}

class _ZCheckBoxState extends State<ZCheckBox> {

  void notify() => setState(() {});

  @override
  Widget build(BuildContext context) {
    var child;
    child = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      decoration:
          widget.value ? widget.checkedDecoration : widget.uncheckedDecoration,
      alignment: Alignment.center,
      child: Text(
        widget.text,
        style: widget.value ? widget.checkedStyle : widget.uncheckedStyle,
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
