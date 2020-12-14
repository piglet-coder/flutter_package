import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/12/14 14:55
/// email zdl328465042@163.com
/// description Scaffold中floatingActionButton的floatingActionButtonLocation属性
/// 在其原有基础上，设置x、y的偏移量
class ZFloatingActionButtonLocationOffset extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX; // X方向的偏移量
  final double offsetY; // Y方向的偏移量
  const ZFloatingActionButtonLocationOffset(
      this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
