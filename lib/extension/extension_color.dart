import 'package:flutter/material.dart';

import 'extension_string.dart';
import 'extension_num.dart';

/// @author zdl
/// date 2021/05/26 14:24
/// email zdl328465042@163.com
/// description 扩展color
extension ExtensionColor on Color {

  /// 解析颜色为字符串，忽略透明度
  String get getColorStr => '#${this.red.toHex}${this.blue.toHex}${this.green.toHex}';
  // String get getColorStr => '#${this.alpha.toHex}${this.red.toHex}${this.blue.toHex}${this.green.toHex}';
}
