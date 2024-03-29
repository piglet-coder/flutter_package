import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_package/flutter_package.dart';

import '../extension/extension_string.dart';
import 'z_toast_util.dart';

/// @author zdl
/// date 2020/3/31 16:24
/// email zdl328465042@163.com
/// description
class ZGlobal {
  const ZGlobal._();

  ///处理接口返回字符串
  static String dealNull(String msg, {String def = '无'}) =>
      msg.isNull ? def : msg;

  ///判空
  static bool isEmpty(data) {
    if (null == data) {
      return true;
    }
    if (data is String) {
      return 0 == data.trim().length;
    } else if (data is List) {
      return data.isEmpty;
    } else if (data is Map) {
      return data.isEmpty;
    }
    return true;
  }

  ///双击退出APP
  static int _last = 0;

  static Future<bool> doubleClickBack(Function onClickBack) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _last > 1000) {
      _last = DateTime.now().millisecondsSinceEpoch;
      null != onClickBack ? onClickBack() : ZToastUtil.show('双击退出APP');
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  /// 点击间隔
  static Future<bool> intervalClick(int interval, Function onClick) {
    assert(null != onClick);
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _last > interval) {
      _last = DateTime.now().millisecondsSinceEpoch;
      onClick();
      return Future.value(false);
    } else {
      _last = DateTime.now().millisecondsSinceEpoch;
      return Future.value(true);
    }
  }

  /// 复制内容
  static void systemCopy(String value) {
    if (value.dealNull.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
  }

  /// 关闭软键盘
  static void closeKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}
