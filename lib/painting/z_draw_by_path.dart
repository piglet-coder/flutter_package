import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/12/9 10:27
/// email zdl328465042@163.com
/// description 通过path画背景
class ZDrawByPath extends StatelessWidget {
  final List<List<Coordinate>> spots;
  final List<Color> colors;

  const ZDrawByPath({
    this.spots,
    this.colors,
  }) : assert(spots != null &&
            colors != null &&
            spots.length != 0 &&
            spots.length == colors.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: _PathPaint(spots, colors),
      ),
    );
  }
}

class _PathPaint extends CustomPainter {
  final List<List<Coordinate>> spots;
  final List<Color> colors;

  const _PathPaint(
    this.spots,
    this.colors,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < spots.length; i++) {
      List<Coordinate> list = spots[i];
      if(list.length == 0) continue;
      paint.color = colors[i];
      Path path = Path();
      path.moveTo(list[0].cx, list[0].cy);
      for (Coordinate coordinate in list) {
        path.lineTo(coordinate.cx, coordinate.cy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//自定义 坐标
class Coordinate {
  final double cx;
  final double cy;

  Coordinate(this.cx, this.cy);
}
