import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/z_color_util.dart';
import '../../extension/extension_num.dart';
import 'z_line.dart';

/// @author zdl
/// date 2020/12/17 14:16
/// email zdl328465042@163.com
/// description 通用左右输入布局
class ZInputInfoRow extends StatelessWidget {
  final String keyStr;
  final double keyFontSize;
  final Color keyFontColor;
  final FontWeight keyFontWeight;
  final int keyFlex;
  final String valueStr;
  final double valueFontSize;
  final Color valueFontColor;
  final FontWeight valueFontWeight;
  final int valueFlex;
  final int valueMaxLine;
  final String valueHintStr;
  final double valueHintFontSize;
  final Color valueHintFontColor;
  final FontWeight valueHintFontWeight;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool readOnly;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType inputType;
  final EdgeInsets contentPadding;
  final bool obscureText;

  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color bgColor;
  final bool valueIsEnd;
  final double centerSpace;
  final bool hasDivider;
  final Color dividerColor;
  final EdgeInsets dividerMargin;

  const ZInputInfoRow({
    this.keyStr,
    this.keyFontSize,
    this.keyFontColor,
    this.keyFontWeight,
    this.keyFlex = 1,
    this.valueStr,
    this.valueFontSize,
    this.valueFontColor,
    this.valueFontWeight,
    this.valueFlex = 2,
    this.valueMaxLine = 1,
    this.valueHintStr,
    this.valueHintFontSize,
    this.valueHintFontColor,
    this.valueHintFontWeight,
    this.controller,
    this.onChanged,
    this.readOnly = false,
    this.inputFormatters,
    this.inputType,
    this.contentPadding,
    this.obscureText,
    this.padding,
    this.margin,
    this.bgColor = Colors.transparent,
    this.valueIsEnd = true,
    this.centerSpace,
    this.hasDivider = true,
    this.dividerColor = Colors.grey,
    this.dividerMargin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    var content;
    content = Container(
      padding: padding,
      margin: margin,
      color: bgColor,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: keyFlex,
            child: Text(
              keyStr ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: keyFontColor ?? ZColorUtil.color_333,
                fontSize: keyFontSize ?? 28.toFit(),
                fontWeight: keyFontWeight ?? FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: centerSpace ?? 20.toFit()),
          Expanded(
            flex: valueFlex,
            child: TextField(
              controller: controller ?? TextEditingController(text: valueStr ?? ''),
              inputFormatters: inputFormatters ?? [],
              keyboardType: inputType,
              textAlign: valueIsEnd ? TextAlign.end : TextAlign.start,
              maxLines: valueMaxLine,
              obscureText: obscureText ?? false,
              style: TextStyle(
                color: valueFontColor ?? ZColorUtil.color_666,
                fontSize: valueFontSize ?? 28.toFit(),
                fontWeight: valueFontWeight ?? FontWeight.normal,
              ),
              onChanged: onChanged,
              readOnly: readOnly,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: contentPadding,
                isDense: contentPadding != null,
                hintText: valueHintStr,
                hintStyle: TextStyle(
                  color: valueHintFontColor ?? ZColorUtil.color_999,
                  fontSize: valueHintFontSize ?? 28.toFit(),
                  fontWeight: valueHintFontWeight ?? FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (hasDivider) {
      content = Column(
        children: [
          content,
          ZLine(
            lineColor: dividerColor,
            margin: dividerMargin,
          ),
        ],
      );
    }
    return content;
  }
}
