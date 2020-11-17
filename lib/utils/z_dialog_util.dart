import 'package:bot_toast/bot_toast.dart';


/// @author zdl
/// date 2020/11/16 15:34
/// email zdl328465042@163.com
/// description dialog工具类
class ZDialogUtil{
  static void showLoading(){
    BotToast.showLoading(duration: null);
  }

  static void hideLoading(){
    BotToast.cleanAll();
  }
}