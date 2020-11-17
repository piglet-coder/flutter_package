import 'package:flutter/material.dart';
import '../widget/z_text.dart';
import '../../utils/z_color_util.dart';

/// @author zdl
/// date 2020/11/9 16:49
/// email zdl328465042@163.com
/// description 弹窗提示widget
class ZDialogHint extends StatelessWidget {
  final String msg;
  final ZDialogHintEnum enumType;
  final double width;
  final double height;
  final Color bgColor;
  final Color fontColor;
  final double fontSize;
  final Widget noDataIcon;
  final double drawablePadding;

  const ZDialogHint(
    this.msg,
    this.enumType,
    this.width,
    this.height,
    this.bgColor,
    this.fontColor,
    this.fontSize,
    this.noDataIcon,
    this.drawablePadding,
  );

  //请使用此方法调用
  static void show(
    BuildContext context, {
    @required String msg,
    @required ZDialogHintEnum enumType,
    double width = 120,
    double height = 90,
    Color bgColor,
    Color fontColor = Colors.white,
    double fontSize = 12,
    Widget noDataIcon,
    double drawablePadding = 10,
  }) {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => ZDialogHint(msg, enumType, width, height, bgColor,
          fontColor, fontSize, noDataIcon, drawablePadding),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget icon;
    switch (enumType) {
      case ZDialogHintEnum.success:
        icon = Icon(Icons.check_circle_outline, color: Colors.white);
        break;
      case ZDialogHintEnum.fail:
      case ZDialogHintEnum.error:
        icon = Icon(Icons.cancel_outlined, color: Colors.white);
        break;
      case ZDialogHintEnum.warn:
        icon = Icon(Icons.error_outline, color: Colors.white);
        break;
    }
    Widget dialog = Center(
      child: ZText(
        msg,
        width: width,
        height: height,
        borderRadius: BorderRadius.circular(8),
        alignment: Alignment.center,
        bgColor: bgColor ?? ZColorUtil.color_333.withOpacity(0.9),
        fontColor: fontColor,
        fontSize: fontSize,
        drawableTop: noDataIcon == null ? icon : noDataIcon,
        drawableTopPadding: drawablePadding,
      ),
    );
    return Material(
      type: MaterialType.transparency,
      child: dialog,
    );
  }
}

enum ZDialogHintEnum { success, fail, error, warn }
