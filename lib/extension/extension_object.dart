
/// @author zdl
/// date 2021/1/7 15:35
/// email zdl328465042@163.com
/// description 扩展object
extension ExtensionList on Object {

  String name<T>(T value){
    return value.toString().split('.').last;
  }
}
