import 'dart:io';

import 'package:path_provider/path_provider.dart';


/// @author zdl
/// date 2020/11/27 17:22
/// email zdl328465042@163.com
/// description io相关工具类
class ZIoUtil {

  const ZIoUtil._();

  /// 获取临时目录路径
  static Future<String> getTempPath() async {
    Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  /// 获取应用文件目录路径
  static Future<String> getDocPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 获取sd卡根路径，仅Android可用
  static Future<String> getSDCardPath() async {
    assert(Platform.isAndroid == true, '该方法只能在Android平台使用');
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }

  /// 获取应用持久存储目录路径，仅ios可用
  static Future<String> getLibraryPath() async {
    assert(Platform.isIOS == true, '该方法只能在IOS平台使用');
    Directory directory = await getLibraryDirectory();
    return directory.path;
  }

  /// 获取下载路径，仅windows可用
  static Future<String> getDownloadsPath() async {
    assert(Platform.isWindows == true, '该方法只能在Windows平台使用');
    Directory directory = await getDownloadsDirectory();
    return directory.path;
  }
}
