import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'z_dashed_border.dart';

/// @author zdl
/// date 2020/11/5 15:00
/// email zdl328465042@163.com
/// description 虚线边框
@Deprecated('\n此方法不能设置圆角，请使用ZDashedBorder')
///[ZDashedBorder]
class ZDashedDecoration extends Decoration {
  final Color color;
  final DecorationImage image;
  final BoxBorder border;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow> boxShadow;
  final Gradient gradient;
  final BlendMode backgroundBlendMode;
  final BoxShape shape;
  final double strokeHeight;
  final double gap;
  final Color dashedColor;
  final bool drawDashed;

  const ZDashedDecoration({
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
    this.strokeHeight = 1.0,
    this.gap = 5.0,
    this.dashedColor,
    this.drawDashed = true,
  })  : assert(shape != null),
        assert(!drawDashed || drawDashed == (dashedColor != null), '画虚线时，dashedColor必须设置'),
        assert(
            backgroundBlendMode == null || color != null || gradient != null,
            "backgroundBlendMode applies to ZDashedDecoration's background color or "
            'gradient, but no color or gradient was provided.');

  ZDashedDecoration copyWith({
    Color color,
    DecorationImage image,
    BoxBorder border,
    BorderRadiusGeometry borderRadius,
    List<BoxShadow> boxShadow,
    Gradient gradient,
    BlendMode backgroundBlendMode,
    BoxShape shape,
  }) {
    return ZDashedDecoration(
      color: color ?? this.color,
      image: image ?? this.image,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      gradient: gradient ?? this.gradient,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
      shape: shape ?? this.shape,
    );
  }

  @override
  bool debugAssertIsValid() {
    assert(shape != BoxShape.circle ||
        borderRadius == null); // Can't have a border radius if you're a circle.
    return super.debugAssertIsValid();
  }

  @override
  EdgeInsetsGeometry get padding => border?.dimensions;

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    Path clipPath;
    switch (shape) {
      case BoxShape.circle:
        clipPath = Path()..addOval(rect);
        break;
      case BoxShape.rectangle:
        if (borderRadius != null)
          clipPath = Path()
            ..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
        break;
    }
    return clipPath;
  }

  ZDashedDecoration scale(double factor) {
    return ZDashedDecoration(
      color: Color.lerp(null, color, factor),
      image: image,
      border: BoxBorder.lerp(null, border, factor),
      borderRadius: BorderRadiusGeometry.lerp(null, borderRadius, factor),
      boxShadow: BoxShadow.lerpList(null, boxShadow, factor),
      gradient: gradient?.scale(factor),
      shape: shape,
    );
  }

  @override
  bool get isComplex => boxShadow != null;

  @override
  ZDashedDecoration lerpFrom(Decoration a, double t) {
    if (a == null) return scale(t);
    if (a is ZDashedDecoration) return ZDashedDecoration.lerp(a, this, t);
    return super.lerpFrom(a, t) as ZDashedDecoration;
  }

  @override
  ZDashedDecoration lerpTo(Decoration b, double t) {
    if (b == null) return scale(1.0 - t);
    if (b is ZDashedDecoration) return ZDashedDecoration.lerp(this, b, t);
    return super.lerpTo(b, t) as ZDashedDecoration;
  }

  static ZDashedDecoration lerp(
      ZDashedDecoration a, ZDashedDecoration b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    if (a == null) return b.scale(t);
    if (b == null) return a.scale(1.0 - t);
    if (t == 0.0) return a;
    if (t == 1.0) return b;
    return ZDashedDecoration(
      color: Color.lerp(a.color, b.color, t),
      image: t < 0.5 ? a.image : b.image,
      border: BoxBorder.lerp(a.border, b.border, t),
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      shape: t < 0.5 ? a.shape : b.shape,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ZDashedDecoration &&
        other.color == color &&
        other.image == image &&
        other.border == border &&
        other.borderRadius == borderRadius &&
        other.boxShadow == boxShadow &&
        other.gradient == gradient &&
        other.shape == shape;
  }

  @override
  int get hashCode {
    return hashValues(
      color,
      image,
      border,
      borderRadius,
      boxShadow,
      gradient,
      shape,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.whitespace
      ..emptyBodyDescription = '<no decorations specified>';

    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<DecorationImage>('image', image,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<BoxBorder>('border', border, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>(
        'borderRadius', borderRadius,
        defaultValue: null));
    properties.add(IterableProperty<BoxShadow>('boxShadow', boxShadow,
        defaultValue: null, style: DiagnosticsTreeStyle.whitespace));
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(EnumProperty<BoxShape>('shape', shape,
        defaultValue: BoxShape.rectangle));
  }

  @override
  bool hitTest(Size size, Offset position, {TextDirection textDirection}) {
    assert(shape != null);
    assert((Offset.zero & size).contains(position));
    switch (shape) {
      case BoxShape.rectangle:
        if (borderRadius != null) {
          final RRect bounds =
              borderRadius.resolve(textDirection).toRRect(Offset.zero & size);
          return bounds.contains(position);
        }
        return true;
      case BoxShape.circle:
        // Circles are inscribed into our smallest dimension.
        final Offset center = size.center(Offset.zero);
        final double distance = (position - center).distance;
        return distance <= math.min(size.width, size.height) / 2.0;
    }
    assert(shape != null);
    return null;
  }

  @override
  _BoxDecorationPainter createBoxPainter([VoidCallback onChanged]) {
    assert(onChanged != null || image == null);
    return _BoxDecorationPainter(this, onChanged);
  }
}

class _BoxDecorationPainter extends BoxPainter {
  _BoxDecorationPainter(this._decoration, VoidCallback onChanged)
      : assert(_decoration != null),
        super(onChanged);

  final ZDashedDecoration _decoration;

  Paint _cachedBackgroundPaint;
  Rect _rectForCachedBackgroundPaint;

  Paint _getBackgroundPaint(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(
        _decoration.gradient != null || _rectForCachedBackgroundPaint == null);

    if (_cachedBackgroundPaint == null ||
        (_decoration.gradient != null &&
            _rectForCachedBackgroundPaint != rect)) {
      final Paint paint = Paint();
      if (_decoration.backgroundBlendMode != null)
        paint.blendMode = _decoration.backgroundBlendMode;
      if (_decoration.color != null) paint.color = _decoration.color;
      if (_decoration.gradient != null) {
        paint.shader = _decoration.gradient
            .createShader(rect, textDirection: textDirection);
        _rectForCachedBackgroundPaint = rect;
      }
      _cachedBackgroundPaint = paint;
    }

    return _cachedBackgroundPaint;
  }

  void _paintBox(
      Canvas canvas, Rect rect, Paint paint, TextDirection textDirection) {
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        canvas.drawCircle(center, radius, paint);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius == null) {
          canvas.drawRect(rect, paint);
        } else {
          canvas.drawRRect(
              _decoration.borderRadius.resolve(textDirection).toRRect(rect),
              paint);
        }
        break;
    }
  }

  void _paintShadows(Canvas canvas, Rect rect, TextDirection textDirection) {
    if (_decoration.boxShadow == null) return;
    for (final BoxShadow boxShadow in _decoration.boxShadow) {
      final Paint paint = boxShadow.toPaint();
      final Rect bounds =
          rect.shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      _paintBox(canvas, bounds, paint, textDirection);
    }
  }

  void _paintBackgroundColor(
      Canvas canvas, Rect rect, TextDirection textDirection) {
    if (_decoration.color != null || _decoration.gradient != null)
      _paintBox(canvas, rect, _getBackgroundPaint(rect, textDirection),
          textDirection);
  }

  DecorationImagePainter _imagePainter;

  void _paintBackgroundImage(
      Canvas canvas, Rect rect, ImageConfiguration configuration) {
    if (_decoration.image == null) return;
    _imagePainter ??= _decoration.image.createPainter(onChanged);
    Path clipPath;
    switch (_decoration.shape) {
      case BoxShape.circle:
        clipPath = Path()..addOval(rect);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius != null)
          clipPath = Path()
            ..addRRect(_decoration.borderRadius
                .resolve(configuration.textDirection)
                .toRRect(rect));
        break;
    }
    _imagePainter.paint(canvas, rect, clipPath, configuration);
  }

  @override
  void dispose() {
    _imagePainter?.dispose();
    super.dispose();
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    _paintShadows(canvas, rect, textDirection);
    _paintBackgroundColor(canvas, rect, textDirection);
    _paintBackgroundImage(canvas, rect, configuration);
    if (_decoration.drawDashed != null && !_decoration.drawDashed) {
      _decoration.border?.paint(
        canvas,
        rect,
        shape: _decoration.shape,
        borderRadius: _decoration.borderRadius as BorderRadius,
        textDirection: configuration.textDirection,
      );
      return;
    }
    Paint dashedPaint = Paint()
      ..color = _decoration.dashedColor
      ..strokeWidth = _decoration.strokeHeight
      ..style = PaintingStyle.stroke;

    Path _topPath = getDashedPath(
      a: math.Point(rect.topLeft.dx, rect.topLeft.dy),
      b: math.Point(rect.topRight.dx, rect.topRight.dy),
      gap: _decoration.gap,
    );

    Path _rightPath = getDashedPath(
      a: math.Point(rect.topRight.dx, rect.topRight.dy),
      b: math.Point(rect.bottomRight.dx, rect.bottomRight.dy),
      gap: _decoration.gap,
    );

    Path _bottomPath = getDashedPath(
      a: math.Point(rect.bottomLeft.dx, rect.bottomLeft.dy),
      b: math.Point(rect.bottomRight.dx, rect.bottomRight.dy),
      gap: _decoration.gap,
    );

    Path _leftPath = getDashedPath(
      a: math.Point(rect.topLeft.dx, rect.topLeft.dy),
      b: math.Point(rect.bottomLeft.dx, rect.bottomLeft.dy),
      gap: _decoration.gap,
    );

    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
    @required math.Point<double> a,
    @required math.Point<double> b,
    @required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  String toString() {
    return 'BoxPainter for $_decoration';
  }
}
