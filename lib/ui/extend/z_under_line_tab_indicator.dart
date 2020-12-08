import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/11/10 14:30
/// email zdl328465042@163.com
/// description TabBar中选中underline，设置indicator属性
/// [indicatorWidth]线宽度，不设置则自适应
/// [borderSide] width：线高度，color：线颜色（等级低于gradient）
/// [insets]线四周的padding
/// [isRound]线是否是圆角的
/// [gradient]线的渐变色（等级高于borderSide中的color）
class ZUnderlineTabIndicator extends Decoration {
  final double indicatorWidth;
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final bool isRound;
  final List<Color> gradient;

  const ZUnderlineTabIndicator({
    this.indicatorWidth,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.blue),
    this.insets = EdgeInsets.zero,
    this.isRound = false,
    this.gradient,
  })  : assert(borderSide != null),
        assert(insets != null);

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is ZUnderlineTabIndicator) {
      return ZUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is ZUnderlineTabIndicator) {
      return ZUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _ZUnderlinePainter createBoxPainter([VoidCallback onChanged]) {
    return _ZUnderlinePainter(this, gradient, isRound, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    double center = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
      indicatorWidth == null ? indicator.left : center - indicatorWidth / 2,
      indicator.bottom - borderSide.width,
      indicatorWidth ?? indicator.width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _ZUnderlinePainter extends BoxPainter {
  final ZUnderlineTabIndicator decoration;
  final bool isRound;
  final List<Color> gradient;

  _ZUnderlinePainter(
      this.decoration, this.gradient, this.isRound, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = isRound ? StrokeCap.round : StrokeCap.square;
    if (gradient != null) {
      paint.shader = ui.Gradient.linear(
          indicator.bottomLeft, indicator.bottomRight, gradient);
    }
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
