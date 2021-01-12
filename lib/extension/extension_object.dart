
/// @author zdl
/// date 2021/1/7 15:35
/// email zdl328465042@163.com
/// description 扩展object
extension ExtensionObject on Object {

  /// 获取枚举中自定义的值
  String get enumName => (this ?? '').toString().split('.').last;
}
