
import 'dart:ui';
import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/3/31 10:45
/// email zdl328465042@163.com
/// description 设备信息相关工具类

class ZDeviceInfoUtil{

  ///屏幕宽
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  ///屏幕高
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  ///获取状态栏高度
  static double statusHeight = MediaQueryData.fromWindow(window).padding.top;

  ///当前屏幕软键盘高度，0代表软键盘未弹出，前提是所有父布局resizeToAvoidBottomInset=false
  static double keyboardHeight(BuildContext context) => MediaQuery.of(context).viewInsets.bottom;
}