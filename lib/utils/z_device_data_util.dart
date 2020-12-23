
import 'dart:ui';
import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/3/31 10:45
/// email zdl328465042@163.com
/// description 设备信息相关工具类

class ZDeviceDataUtil{

  const ZDeviceDataUtil._();

  static MediaQueryData _mediaQueryData = MediaQueryData.fromWindow(window);

  /// padding
  static EdgeInsets get padding => _mediaQueryData.padding;

  ///屏幕宽
  static double get screenWidth => _mediaQueryData.size.width;

  ///屏幕高
  static double get screenHeight => _mediaQueryData.size.height;

  ///获取上方状态栏高度
  static double topBarHeight = padding.top;

  ///获取下方状态栏高度
  static double botBarHeight = padding.bottom;

  ///当前屏幕软键盘高度，0代表软键盘未弹出，前提是所有父布局resizeToAvoidBottomInset=false
  static double keyboardHeight(BuildContext context) => MediaQuery.of(context).viewInsets.bottom;
}