import 'extension_string.dart';

/// @author zdl
/// date 2020/11/10 16:00
/// email zdl328465042@163.com
/// description 扩展num
extension ExtensionNum on num{

  static String zh_cn = '零一二三四五六七八九';
  static String zh_ft = '零壹贰叁肆伍陆柒捌玖';

  ///处理null
  num get dealNull => this ?? 0;

  ///阿拉伯数字转中文
  String toZh({bool isCn = true}){
    String zh = '';
    String numStr = this.dealNull.toString();
    for(int i = 0;i<numStr.length;i++){
      var index = numStr.findChar(i+1).toInt;
      zh += index == null ? '点' : (isCn ? zh_cn[index] : zh_ft[index]);
    }
    return zh;
  }
}