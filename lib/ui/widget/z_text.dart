import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/10/30 10:50
/// email zdl328465042@163.com
/// description 文本控件
///
/// 图层从上到下:bgImg>gradient>bgColor
/// 设置了shape: BoxShape.circle，则不能再设置borderRadius
/// border: Border.all(color: Colors.black, width: 2)
/// borderRadius: BorderRadius.all(Radius.circular(5))
/// shape: BoxShape.circle
/// 阴影位置由offset决定,阴影模糊层度由blurRadius大小决定（大就更透明更扩散），阴影模糊大小由spreadRadius决定
/// boxShadow: [BoxShadow(color: Colors.green,offset: Offset(5, 5),blurRadius: 10,spreadRadius: 5,)]
/// 环形渲染:RadialGradient，扫描式渐变:SweepGradient，线性渐变:LinearGradient
/// gradient: LinearGradient(colors: [Colors.red, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight)
class ZText extends StatelessWidget {
  ///Text属性
  final String data;
  final TextStyle style;
  final TextDecoration textDecoration;
  final Color textDecorationColor;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;

  ///外层Container属性
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final AlignmentGeometry alignment;
  final Color bgColor;
  final String bgImg;
  final BoxBorder border;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow> boxShadow;
  final BoxShape shape;
  final Gradient gradient;

  ///上下左右图片
  final Widget drawableStart;
  final Widget drawableTop;
  final Widget drawableEnd;
  final Widget drawableBottom;
  final double drawableStartPadding;
  final double drawableTopPadding;
  final double drawableEndPadding;
  final double drawableBottomPadding;
  final double drawablePadding;
  final bool isFill;

  final VoidCallback onTap;
  final GestureRecognizer onDrawableTap;

  const ZText(
      this.data, {
        this.style,
        this.textDecoration,
        this.textDecorationColor,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.width,
        this.height,
        this.padding,
        this.margin,
        this.alignment,
        this.bgColor,
        this.bgImg,
        this.border,
        this.borderRadius,
        this.boxShadow,
        this.shape = BoxShape.rectangle,
        this.gradient,
        this.drawableStart,
        this.drawableTop,
        this.drawableEnd,
        this.drawableBottom,
        this.drawableStartPadding,
        this.drawableTopPadding,
        this.drawableEndPadding,
        this.drawableBottomPadding,
        this.drawablePadding,
        this.isFill = false,
        this.onTap,
        this.onDrawableTap,
      });

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defStyle = DefaultTextStyle.of(context);
    TextStyle effectiveStyle = style;
    if (effectiveStyle == null || effectiveStyle.inherit) {
      effectiveStyle = defStyle.style.merge(effectiveStyle);
    }

    TextSpan text = TextSpan(
      text: data,
      style: effectiveStyle,
    );

    TextSpan tsStart, tsTop, tsEnd, tsBottom;
    if (null != drawableStart) {
      tsStart = TextSpan(
        children: [
          WidgetSpan(child: drawableStart),
          WidgetSpan(child: SizedBox(width: drawableStartPadding ?? drawablePadding ?? 0)),
        ],
        recognizer: onDrawableTap,
      );
    }
    if (null != drawableTop) {
      tsTop = TextSpan(
        children: [
          WidgetSpan(child: drawableTop),
          WidgetSpan(child: SizedBox(height: drawableTopPadding ?? drawablePadding ?? 0)),
        ],
        recognizer: onDrawableTap,
      );
    }
    if (null != drawableEnd) {
      tsEnd = TextSpan(
        children: [
          WidgetSpan(child: SizedBox(width: drawableEndPadding ?? drawablePadding ?? 0)),
          WidgetSpan(child: drawableEnd),
        ],
        recognizer: onDrawableTap,
      );
    }
    if (null != drawableBottom) {
      tsBottom = TextSpan(
        children: [
          WidgetSpan(child: SizedBox(height: drawableBottomPadding ?? drawablePadding ?? 0)),
          WidgetSpan(child: drawableBottom),
        ],
        recognizer: onDrawableTap,
      );
    }

    Widget result;
    result = LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double minWidth = constraints.minWidth;
      final double maxWidth = constraints.maxWidth;
      final textAlign = this.textAlign ?? defStyle.textAlign ?? TextAlign.center;
      TextSpan textSpan;
      if (null != tsStart) {
        textSpan = TextSpan(children: [
          tsStart,
          text,
        ]);
      } else if (null != tsTop) {
        text = TextSpan(
          text: '\n$data',
          style: effectiveStyle,
        );
        textSpan = TextSpan(children: [
          tsTop,
          text,
        ]);
      } else if (null != tsEnd) {
        // TODO: drawableEnd暂未实现
        if (maxLines == 1) {
          TextPainter tp = TextPainter(
            text: tsEnd,
            textAlign: textAlign,
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          );
          tp.layout(minWidth: minWidth, maxWidth: maxWidth);
          final drawableSize = tp.size;

          tp.text = text;
          tp.layout(minWidth: minWidth, maxWidth: maxWidth);
          final textSize = tp.size;

          if (tp.didExceedMaxLines) {
            final position = tp.getPositionForOffset(Offset(
              textSize.width - drawableSize.width,
              textSize.height,
            ));
            final endOffset = tp.getOffsetBefore(position.offset) ?? 0;
            textSpan = TextSpan(
              text: '${data.substring(0, max(endOffset, 0))}… ',
              style: effectiveStyle,
              children: [tsEnd],
            );
          } else {
            textSpan = TextSpan(
              children: [
                text,
                tsEnd,
              ],
            );
          }
        } else {
          textSpan = TextSpan(children: [
            text,
            tsEnd,
          ]);
        }
      } else if (null != tsBottom) {
        TextPainter tp = TextPainter(
          text: text,
          textAlign: textAlign,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(minWidth: minWidth, maxWidth: maxWidth);
        final textSize = tp.size;

        if (tp.didExceedMaxLines) {
          final position = tp.getPositionForOffset(Offset(
            textSize.width,
            textSize.height,
          ));
          final endOffset = tp.getOffsetBefore(position.offset) ?? 0;
          textSpan = TextSpan(
            text: '${data.substring(0, max(endOffset, 0))}… \n',
            style: effectiveStyle,
            children: [tsBottom],
          );
        } else {
          text = TextSpan(
            text: '$data\n',
            style: effectiveStyle,
          );
          textSpan = TextSpan(
            children: [
              text,
              tsBottom,
            ],
          );
        }
      } else {
        textSpan = text;
      }
      return RichText(
        text: textSpan,
        softWrap: true,
        textAlign: textAlign,
        maxLines: maxLines != null ? ((tsTop != null || tsBottom != null) ? maxLines + 1 : maxLines) : null,
        overflow: overflow ?? TextOverflow.clip,
      );
    });

    //外层修饰
    result = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: bgColor,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        shape: shape,
        gradient: gradient,
        image: null == bgImg ? null : DecorationImage(image: AssetImage(bgImg), fit: BoxFit.cover),
      ),
      child: result,
    );
    //点击事件
    if (onTap != null) {
      result = InkWell(
        onTap: onTap,
        child: result,
      );
    }
    return result;
  }
}
