import 'package:bot_toast/bot_toast.dart';

/// @author zdl
/// date 2020/11/16 10:56
/// email zdl328465042@163.com
/// description toast工具类
class ZToastUtil {
  const ZToastUtil._();

  ///Toast.show
  static void show(String text,
      {Duration duration = const Duration(seconds: 1)}) {
    try{
      BotToast.showText(text: text, duration: duration);
    }catch(e){
      print(e);
      throw ('ZToastUtil.show：Toast未初始化，请在main.drat外层配置ZBaseMainConfig');
      // @override
      // Widget build(BuildContext context) {
      //   return ZBaseMainConfig(
      //     title: 'appName',
      //     theme: ThemeData(
      //       // This is thy
      //       primarySwatch: Colors.blue,
      //       visualDensity: VisualDensity.adaptivePlatformDensity,
      //     ),
      //     child: HomePage(),
      //   );
      // }
    }
  }

// ///Toast.show
// static showNotification(String text,{Duration duration = const Duration(seconds: 1)}){
//   BotToast.showNotification(text: text, duration: duration);
// }
}
