import 'package:flutter/material.dart';
import 'package:flutter_package/flutter_package.dart';

/// @author zdl
/// date 2021/05/18 14:17
/// email zdl328465042@163.com
/// description 仿微信底部弹窗
class ZWechatOptionPicker extends StatelessWidget {
  final List<String> option;
  final Color bgColor;
  final double radius;
  final TextStyle style;
  final Map<int, TextStyle> customStyle;
  final ZSingleCallback callback;

  const ZWechatOptionPicker._(
    this.option,
    this.bgColor,
    this.radius,
    this.style,
    this.customStyle,
    this.callback,
  );

  static void show({
    @required BuildContext context,
    @required List<String> option,
    Color bgColor = Colors.white,
    double radius,
    TextStyle style,
    Map<int, TextStyle> customStyle,
    ZSingleCallback callback,
  }) {
    TextStyle defStyle = TextStyle(color: ZColorUtil.color_333);
    showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius ?? 10.toFit())),
        ),
        builder: (BuildContext context) {
          return ZWechatOptionPicker._(option, bgColor, radius ?? 10.toFit(), style ?? defStyle, customStyle, callback);
        });
  }

  @override
  Widget build(BuildContext context) {
    option.add('取消');
    List<Widget> children = [];
    for (int i = 0; i < option.length; i++) {
      Widget text;
      if ((customStyle ?? {}).containsKey(i)) {
        text = Text(option[i], style: customStyle[i]);
      } else {
        text = Text(option[i], style: style);
      }
      children.add(InkWell(
        onTap: (){
          if(i != option.length-1 && callback != null) callback(i);
          ZIntentUtil.finish(context);
        },
        child: Container(
          width: double.infinity,
          height: 100.toFit(),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: ZColorUtil.color_line, width: 1.toFit())),
          ),
          alignment: Alignment.center,
          child: text,
        ),
      ));
    }
    children.insert(
        option.length - 1,
        InkWell(
          onTap: () => ZIntentUtil.finish(context),
          child: Container(height: 20.toFit(), color: ZColorUtil.color_line),
        ));
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius ?? 10.toFit())),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
