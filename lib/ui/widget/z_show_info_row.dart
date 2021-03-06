import 'package:flutter/material.dart';
import '../../utils/z_color_util.dart';
import '../../extension/extension_num.dart';
import 'z_line.dart';

/// @author zdl
/// date 2020/12/7 11:26
/// email zdl328465042@163.com
/// description 通用左右显示布局
class ZShowInfoRow extends StatelessWidget {
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
  final Widget arrowRightIcon;

  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color bgColor;
  final bool valueIsEnd;
  final double centerSpace;
  final bool hasDivider;
  final Color dividerColor;
  final EdgeInsets dividerMargin;
  final VoidCallback onTap;
  final double arrowRightSpace;
  final Color arrowRightColor;

  const ZShowInfoRow({
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
    this.arrowRightIcon,
    this.padding,
    this.margin,
    this.bgColor = Colors.transparent,
    this.valueIsEnd = true,
    this.centerSpace,
    this.hasDivider = true,
    this.dividerColor = Colors.grey,
    this.dividerMargin = const EdgeInsets.all(0),
    this.onTap,
    this.arrowRightSpace,
    this.arrowRightColor,
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
            child: Text(
              valueStr ?? '',
              textAlign: valueIsEnd ? TextAlign.end : TextAlign.start,
              maxLines: valueMaxLine,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valueFontColor ?? ZColorUtil.color_666,
                fontSize: valueFontSize ?? 28.toFit(),
                fontWeight: valueFontWeight ?? FontWeight.normal,
              ),
            ),
          ),
          Visibility(
            visible: onTap != null,
            child: Container(
              margin: EdgeInsets.only(left: arrowRightSpace ?? 10.toFit()),
              child: arrowRightIcon ??
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: arrowRightColor ?? Colors.grey,
                  ),
            ),
          ),
        ],
      ),
    );
    if (hasDivider) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          ZLine(
            lineColor: dividerColor,
            margin: dividerMargin,
          ),
        ],
      );
    }
    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}
