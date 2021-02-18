import 'package:flutter/material.dart';
import '../../extension/extension_num.dart';

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
  final Alignment alignment;
  final String text;
  final TextStyle checkedStyle;
  final Decoration checkedDecoration;
  final TextStyle uncheckedStyle;
  final Decoration uncheckedDecoration;

  final bool noBox;
  final bool tristate;
  final Widget checkIcon;
  final Widget uncheckIcon;
  final Widget indeterminateCheckIcon;
  final double drawablePadding;
  final Color checkColor;
  final Color uncheckColor;
  final Color indeterminateCheckColor;
  final MainAxisSize mainAxisSize;

  ZCheckBox({
    this.value = false,
    this.tag,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.onChanged,
    this.text,
    this.checkedStyle,
    this.checkedDecoration,
    this.uncheckedStyle,
    this.uncheckedDecoration,
    this.noBox = false,
    this.tristate = false,
    this.checkIcon,
    this.uncheckIcon,
    this.indeterminateCheckIcon,
    this.drawablePadding,
    this.checkColor,
    this.uncheckColor,
    this.indeterminateCheckColor,
    this.mainAxisSize = MainAxisSize.min,
  }) : assert(tristate != null),
        assert(tristate || value != null);

  _ZCheckBoxState _state;

  @override
  _ZCheckBoxState createState() {
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
    child = Text(
      widget.text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style:
          widget.value != false ? widget.checkedStyle : widget.uncheckedStyle,
    );
    if (widget.noBox != true) {
      var box;
      if (widget.value == false) {
        box = widget.uncheckIcon ??
            Icon(Icons.check_box_outline_blank, color: widget.uncheckColor);
      }else{
        box = widget.checkIcon ??
            Icon(Icons.check_box, color: widget.checkColor);
      }
      if (widget.tristate == true) {
        if (widget.value == null) {
          box = widget.indeterminateCheckIcon ??
              Icon(Icons.indeterminate_check_box,
                  color: widget.indeterminateCheckColor);
        }
      }
      child = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          box,
          SizedBox(width: widget.drawablePadding ?? 10.toFit()),
          child,
        ],
      );
    }
    child = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      decoration:
          widget.value == true ? widget.checkedDecoration : widget.uncheckedDecoration,
      alignment: widget.alignment,
      child: child,
    );
    return InkWell(
      onTap: () {
        widget.value = widget.value == false;
        if (widget.onChanged != null)
          switch (widget.value) {
            case false:
              widget.onChanged(false);
              break;
            case true:
              widget.onChanged(true);
              break;
          }
        setState(() {});
      },
      child: child,
    );
  }
}
