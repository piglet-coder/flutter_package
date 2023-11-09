import '../utils/z_device_data_util.dart';

import 'extension_string.dart';

/// @author zdl
/// date 2020/11/10 16:00
/// email zdl328465042@163.com
/// description 扩展num
extension ExtensionNum on num {
  static String zhCn = '零一二三四五六七八九';
  static String zhFt = '零壹贰叁肆伍陆柒捌玖';

  ///处理null
  num get dealNull => this ?? 0;

  ///阿拉伯数字转中文
  String toZh({bool isCn = true}) {
    String zh = '';
    String numStr = this.dealNull.toString();
    for (int i = 0; i < numStr.length; i++) {
      var index = numStr.findChar(i + 1).toInt;
      zh += index == null ? '点' : (isCn ? zhCn[index] : zhFt[index]);
    }
    return zh;
  }

  /// 月份转中文
  String toTimeZh() {
    String zh = '';
    String numStr = this.dealNull.toString();
    if (numStr.length == 1) {
      zh = zhCn[numStr.toInt];
    } else if (numStr == '10') {
      zh = '十';
    } else if (numStr.length == 2) {
      zh = '十${zhCn[numStr.findChar(1).toInt]}';
    }
    return zh;
  }

  ///适配不同分辨率的手机像素
  num toFit({int uiWidth = 750}) {
    var ratio = ZDeviceDataUtil.screenWidth / uiWidth;
    return this.dealNull * ratio;
  }

  bool get isMonth => this != null && this is int && this >= 1 && this <= 12;

  bool get isYear => this != null && this is int && this >= 0 && this <= 10000;

  String get toHex => '${this < 16 ? '0' : ''}${this.toInt().toRadixString(16)}';
}
