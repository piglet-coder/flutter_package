import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/z_color_util.dart';

/// @author zdl
/// date 2020/7/17 11:14
/// email zdl328465042@163.com
/// description 页面基类
class ZBaseRoot extends StatefulWidget {
  /*整体配置*/
  final GestureTapCallback clickBack;
  final Widget body;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;
  final Widget floatingActionButton;
  final Function onWillPop;

  /*标题栏配置*/
  final String title;
  final Widget titleWidget;
  final bool centerTitle;
  final Widget leading;
  final bool canBack;

  //常用的用IconButton来表示，不常用的用PopupMenuButton来显示三个点，点击展开
  final List<Widget> actions;
  final Color barBackgroundColor;
  final bool isDarkTheme;

  ZBaseRoot({
    Key key,
    this.clickBack,
    this.body,
    this.backgroundColor = Colors.white,
    this.resizeToAvoidBottomInset,
    this.floatingActionButton,
    this.onWillPop,
    this.title = '',
    this.titleWidget,
    this.centerTitle = true,
    this.leading = const Icon(Icons.arrow_back_ios),
    this.canBack = true,
    this.actions,
    this.barBackgroundColor,
    this.isDarkTheme = true,
  }) : super(key: key);

  @override
  _ZBaseRootState createState() => _ZBaseRootState();
}

class _ZBaseRootState extends State<ZBaseRoot> {
  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      appBar: AppBar(
        title: widget.titleWidget ??
            Text(
              widget.title,
              style: TextStyle(
                color: widget.isDarkTheme ? Colors.white : ZColorUtil.color_333,
              ),
            ),
        centerTitle: widget.centerTitle,
        leading: (null == widget.leading || !widget.canBack)
            ? null
            : IconButton(
                icon: widget.leading,
                onPressed: widget.clickBack ??
                    () {
                      if (Navigator.canPop(context))
                        Navigator.of(context).pop();
                      else
                        SystemNavigator.pop();
                    },
              ),
        actions: widget.actions,
        backgroundColor: widget.barBackgroundColor ?? widget.isDarkTheme
            ? null
            : Colors.white,
        brightness: widget.isDarkTheme ? Brightness.dark : Brightness.light,
        iconTheme: IconThemeData(
          color: widget.isDarkTheme ? Colors.white : ZColorUtil.color_333,
        ),
      ),
      body: widget.body,
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
    );
    return (widget.canBack && widget.onWillPop == null)
        ? scaffold
        : WillPopScope(
            onWillPop: widget.onWillPop != null
                ? widget.onWillPop
                : () async => false,
            child: scaffold,
          );
  }
}
