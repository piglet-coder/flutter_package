import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// @author zdl
/// date 2020/7/17 9:51
/// email zdl328465042@163.com
/// description 请在main.drat中进行全局配置，包含点击页面空白处隐藏软键盘
class ZBaseMainConfig extends StatelessWidget {
  final Widget child;
  final String title;
  final ThemeData theme;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  ZBaseMainConfig({
    @required this.child,
    this.title = '',
    this.theme,
    this.localizationsDelegates,
  });

  @override
  Widget build(BuildContext context) {
    //本地国际化
    var delegates = (this.localizationsDelegates ?? []).toList();
    delegates.addAll([
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate
    ]);
    return MaterialApp(
      builder: BotToastInit(),
      title: title,
      theme: theme,
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: delegates,
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
      ],
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
