import 'extension_string.dart';

/// @author zdl
/// date 2020/10/22 14:50
/// email zdl328465042@163.com
/// description 扩展List
extension ExtensionList on List {
  bool get isList => null != this || !(this is List);

  List get dealNotList => isList ? this : [];

  /// 拆分列表后拼接为字符串
  String toStringWith({String splitUnit = '、', String def = '无'}) {
    String str = this.dealNotList.toString();
    return str
        .substring(1, str.length - 1)
        .replaceAll(', ', splitUnit)
        .dealData(def: def);
  }

  /// 获取枚举中自定义的值
  String getNameAt(int index) {
    if (this.dealNotList.length <= index)
      throw ('ArrayIndexOutOfBoundsException');
    else
      return this[index].toString().split('.').last;
  }
}
