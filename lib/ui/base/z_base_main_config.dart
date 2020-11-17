import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/7/17 9:51
/// email zdl328465042@163.com
/// description 请在main.drat中进行全局配置，包含点击页面空白处隐藏软键盘
class ZBaseMainConfig extends StatelessWidget {
  final Widget child;
  final String title;
  final ThemeData theme;

  ZBaseMainConfig({
    @required this.child,
    this.title,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      title: title,
      theme: theme,
      navigatorObservers: [BotToastNavigatorObserver()],
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}
