class ZConfigUtil{
  static bool isDebug = !bool.fromEnvironment('dart.vm.product');

  static String appName({String appName = 'APP'}) => isDebug ? '$appName(debug)' : appName;
}