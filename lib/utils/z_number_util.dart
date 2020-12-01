/// @author zdl
/// date 2020/10/15 11:55
/// email zdl328465042@163.com
/// description 数字相关工具类
class ZNumberUtil {
  const ZNumberUtil._();

  /// 十进制转二进制
  static String toBinary(int value) {
    value = value ?? 0;
    String binary = value.toRadixString(2);
    return '${'0' * (8 - binary.length)}$binary';
  }

  /// 十进制转十六进制
  static String toHex(int value){
    value = value ?? 0;
    return '0x${value < 16 ? '0' : ''}${value.toRadixString(16)}';
  }

  /// 二进制转十进制
  static int binary2int(String value){
    value = value ?? '00000000';
    return int.tryParse(value, radix: 2);
  }

  /// 二进制转十六进制
  static String binary2hex(String value){
    value = value ?? '00000000';
    return toHex(binary2int(value));
  }

  /// 十六进制转十进制
  static int hex2int(String value){
    value = value ?? '0x00';
    return int.tryParse(value);
  }

  /// 十六进制转二进制
  static String hex2binary(String value){
    value = value ?? '0x00';
    return toBinary(hex2int(value));
  }
}
