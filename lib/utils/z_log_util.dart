import 'dart:developer';


/// @author zdl
/// date 2020/11/16 10:56
/// email zdl328465042@163.com
/// description log工具类
class ZLogUtil {
  static i(String msg, {String tag = '',}){
    log(msg, name: tag);
  }
}
