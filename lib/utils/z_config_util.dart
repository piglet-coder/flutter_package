class ZConfigUtil{

  const ZConfigUtil._();

  static bool isDebug = !bool.fromEnvironment('dart.vm.product');

  static String appName({String appName = 'APP'}) => isDebug ? '$appName(debug)' : appName;

  /// 设置百度移动统计页面开始结束方法
  static Function(String) pageStart;
  static Function(String) pageEnd;
}