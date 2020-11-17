import 'package:flutter_package/utils/z_json_util.dart';

/// @author zdl
/// date 2020/11/13 10:14
/// email zdl328465042@163.com
/// description 网络请求返回参数bean类shell
class ZResponseShell<T> {
  int code;
  String msg;
  T data;

  ZResponseShell(this.code, this.msg, {this.data});

  factory ZResponseShell.fromJson(Map<String, dynamic> map) => ZResponseShell(
        map['code'],
        map['msg'],
        data: map['data'],
      );
}
