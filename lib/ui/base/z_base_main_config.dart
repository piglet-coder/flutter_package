import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_package/extend/z_chinese_cupertino_localizations.dart';

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
      DefaultCupertinoLocalizations.delegate,
      ZChineseCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
    ]);
    final botToastBuilder = BotToastInit();
    return MaterialApp(
      builder: (context, child) {
        child = Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            behavior: HitTestBehavior.translucent,
            child: child,
          ),
        );
        child = botToastBuilder(context, child);
        return child;
      },
      title: title,
      theme: theme,
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: delegates,
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
      ],
      home: child,
    );
  }
}
