import 'package:flutter/material.dart';

/// @author zdl
/// date 2021/1/20 13:57
/// email zdl328465042@163.com
/// description 可收起、展开的text
class ZExpandableText extends StatefulWidget {
  final String data;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final Color expandColor;
  final String expandText;
  final String narrowText;
  final bool expandIsEnd;

  ZExpandableText(
    this.data, {
    this.fontColor,
    this.fontSize,
    this.fontWeight,
    this.maxLines = 3,
    this.expandColor,
    this.expandText = '展开 ∨',
    this.narrowText = '收起 ∧',
    this.expandIsEnd = true,
  }) : assert(data != null);

  @override
  _ZExpandableTextState createState() => _ZExpandableTextState();
}

class _ZExpandableTextState extends State<ZExpandableText> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      color: widget.fontColor,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );
    return LayoutBuilder(
      builder: (context, size) {
        var tp = TextPainter(
          text: TextSpan(
            text: widget.data,
            style: style,
          ),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: size.maxWidth);
        if (!tp.didExceedMaxLines) return Text(widget.data, style: style);
        return Column(
          crossAxisAlignment: widget.expandIsEnd
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              widget.data,
              style: style,
              maxLines: expand ? null : widget.maxLines,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  expand = !expand;
                });
              },
              child: Text(
                expand ? widget.narrowText : widget.expandText,
                style: TextStyle(
                  color: widget.expandColor ?? Colors.blue,
                  fontSize: widget.fontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
