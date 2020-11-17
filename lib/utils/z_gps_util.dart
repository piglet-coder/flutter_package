import 'dart:math';
import '../extension/extension_string.dart';

/// @author zdl
/// date 2020/7/23 10:15
/// email zdl328465042@163.com
/// description GPS相关工具类

class ZGPSUtil {

  //地球半径，单位米
  static final double _EARTH_RADIUS = 6371393;

  static double _rad(double d) {
    return d * pi / 180.0;
  }

  /// 计算两点间距离，保留三位小数
  /// return double(unit:km)
  static double distance(double lat1, double lng1, double lat2, double lng2) {
    double radLat1 = _rad(lat1);
    double radLat2 = _rad(lat2);
    double a = radLat1 - radLat2;
    double b = _rad(lng1) - _rad(lng2);
    double s = 2 *
        asin(sqrt(pow(sin(a / 2), 2) +
            cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    return (s * _EARTH_RADIUS).toStringAsFixed(3).toDouble;
  }
}
