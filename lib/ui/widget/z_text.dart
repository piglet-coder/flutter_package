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
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
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

  const ZText(this.data, {
    this.fontColor,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.textDecorationColor,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
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
  });

  @override
  Widget build(BuildContext context) {
    var text;
    //文本
    text = Text(
      data,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        decorationColor: textDecorationColor,
      ),
    );
    //上下或左右的图片
    bool onlyRow = (null != drawableStart || null != drawableEnd) &&
        (null == drawableTop && null == drawableBottom);
    bool onlyColumn = (null != drawableTop || null != drawableBottom) &&
        (null == drawableStart && null == drawableEnd);
    if (onlyRow) {
      text = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (null != drawableStart) drawableStart,
          SizedBox(
              width: null == drawableStartPadding
                  ? drawablePadding
                  : drawableStartPadding),
          isFill ? Expanded(child: text) : text,
          SizedBox(
              width: null == drawableEndPadding
                  ? drawablePadding
                  : drawableEndPadding),
          if (null != drawableEnd) drawableEnd,
        ],
      );
    } else if (onlyColumn) {
      text = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (null != drawableTop) drawableTop,
          SizedBox(
              height: null == drawableTopPadding
                  ? drawablePadding
                  : drawableTopPadding),
          isFill ? Expanded(child: text) : text,
          SizedBox(
              height: null == drawableBottomPadding
                  ? drawablePadding
                  : drawableBottomPadding),
          if (null != drawableBottom) drawableBottom,
        ],
      );
    }
    //外层修饰
    text = Container(
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
        image: null == bgImg
            ? null
            : DecorationImage(image: AssetImage(bgImg), fit: BoxFit.cover),
      ),
      child: text,
    );
    //点击事件
    if (onTap != null) {
      text = InkWell(
        onTap: onTap,
        child: text,
      );
    }
    return text;
  }
}
