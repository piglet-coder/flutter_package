import 'dart:math';
import 'dart:ui';


/// @author zdl
/// date 2020/3/31 10:45
/// email zdl328465042@163.com
/// description 颜色工具类
class ZColorUtil {

  static const Color color_333 = Color(0xff333333);
  static const Color color_666 = Color(0xff666666);
  static const Color color_999 = Color(0xff999999);

  ///获取随机颜色
  static Color getRandomColor() {
    Random random = Random.secure();
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}
