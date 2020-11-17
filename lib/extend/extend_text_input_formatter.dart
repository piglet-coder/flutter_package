import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extension/extension_string.dart';

/// @author zdl
/// date 2020/8/21 17:44
/// email zdl328465042@163.com
/// description TextInputFormatter，TextField->inputFormatters
/// 基础常用[ZInputFormatterCommon]
/// 纠正不规范的输入数字[ZInputFormatterNumBeautiful]
/// 限制TextField输入小数位数[ZInputFormatterDecimalDigits]
/// 限制TextField输入最大、最小数[ZInputFormatterNumMaxMin]

RegExp _regExpNum = RegExp(r'[0-9.]');

///基础常用
class ZInputFormatterCommon {
  //单行
  static final TextInputFormatter singleLine =
      FilteringTextInputFormatter.deny('\n');

  //数字
  static final TextInputFormatter num =
      FilteringTextInputFormatter.allow(_regExpNum);

  //密码
  static final TextInputFormatter pwd =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));

  //邮箱
  static final TextInputFormatter email =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]'));
}

///纠正不规范的输入数字
class ZInputFormatterNumBeautiful extends TextInputFormatter {
  ZInputFormatterNumBeautiful();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text != '' && !_regExpNum.hasMatch(newValue.text)) {
      return oldValue;
    }
    String neatValue;
    String newText = newValue.text;
    if (newText.contains('.')) {
      if (newText == '.') {
        neatValue = '0.';
      }
    } else {
      neatValue = newValue.text == '' ? '' : newText.toInt.toString();
    }
    return neatValue == null
        ? newValue
        : TextEditingValue(
            text: neatValue,
            selection: TextSelection.collapsed(offset: neatValue.length));
  }
}

///限制TextField输入小数位数
class ZInputFormatterDecimalDigits extends TextInputFormatter {
  final int decimalDigits;

  ZInputFormatterDecimalDigits(
    this.decimalDigits,
  ) : assert(decimalDigits != null && decimalDigits > 0,
            'ZInputFormatterDecimalDigits:请正确的设置decimalDigits');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newTxt = newValue.text.replaceExceptFirst('.', '');
    List<String> newArr = newTxt.split('.');
    if (newArr.length != 1 && newArr[1].length > decimalDigits) {
      String value = '${newArr[0]}.${newArr[1].substring(0, decimalDigits)}';
      return TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length));
    }
    return TextEditingValue(
        text: newTxt,
        selection: TextSelection.collapsed(offset: newTxt.length));
  }
}

///限制TextField输入最大、最小数
class ZInputFormatterNumMaxMin extends TextInputFormatter {
  final int value;
  final bool isMax;

  ZInputFormatterNumMaxMin(
    this.value, {
    @required this.isMax,
  }) : assert(isMax != null);

  ZInputFormatterNumMaxMin.max(this.value) : isMax = true;

  //'此处体验不好，不推荐使用'
  @Deprecated('\n此处体验不好，不推荐使用\n请在TextField的onSubmitted中判断')
  ZInputFormatterNumMaxMin.min(this.value) : isMax = false;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text != '' && !_regExpNum.hasMatch(newValue.text)) {
      return oldValue;
    }
    double inputValue = newValue.text.toDouble ?? 0;
    return (isMax ? inputValue <= value : inputValue >= value)
        ? newValue
        : TextEditingValue(
            text: value.toString(),
            selection:
                TextSelection.collapsed(offset: value.toString().length));
  }
}
