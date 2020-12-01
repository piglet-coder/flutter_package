import 'dart:io';

import 'package:path_provider/path_provider.dart';


/// @author zdl
/// date 2020/11/27 17:22
/// email zdl328465042@163.com
/// description io相关工具类
class ZIoUtil {

  const ZIoUtil._();

  /// 获取sd卡根路径
  static Future<String> getSDCardPath() async {
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }

  /// 获取临时目录路径
  static Future<String> getTempPath() async {
    Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  /// 获取文档目录路径
  static Future<String> getDocPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
