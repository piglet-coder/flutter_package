import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_package/flutter_package.dart';
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
  final SystemUiOverlayStyle statusBarStyle;
  final Widget bottomNavigationBar;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool extendBody;
  final bool belowStatusBar;
  final Widget drawer;
  final Widget endDrawer;

  /*标题栏配置*/
  final dynamic title;
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
    this.statusBarStyle,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.extendBody = false,
    this.belowStatusBar = true,
    this.drawer,
    this.endDrawer,
    this.title,
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
    Widget titleWidget;
    if (widget.title is String) {
      titleWidget = Text(
        widget.title,
        style: TextStyle(
          color: widget.isDarkTheme ? Colors.white : ZColorUtil.color_333,
        ),
      );
    } else if (widget.title is Widget) {
      titleWidget = widget.title;
    }
    Widget child;
    child = Scaffold(
      key: widget.key,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      appBar: titleWidget == null
          ? (widget.belowStatusBar
              ? PreferredSize(
                  preferredSize:
                      Size.fromHeight(ZDeviceDataUtil.topBarHeight * 0.07),
                  child: SafeArea(
                    top: true,
                    child: Offstage(),
                  ),
                )
              : null)
          : AppBar(
              title: titleWidget,
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
              backgroundColor: widget.barBackgroundColor ??
                  (widget.isDarkTheme ? null : Colors.white),
              brightness:
                  widget.isDarkTheme ? Brightness.dark : Brightness.light,
              iconTheme: IconThemeData(
                color: widget.isDarkTheme ? Colors.white : ZColorUtil.color_333,
              ),
            ),
      body: widget.body,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      extendBody: widget.extendBody ?? false,
    );
    if (widget.statusBarStyle != null) {
      child = AnnotatedRegion<SystemUiOverlayStyle>(
        value: widget.statusBarStyle,
        child: child,
      );
    }

    return (widget.canBack && widget.onWillPop == null)
        ? child
        : WillPopScope(
            onWillPop:
                widget.onWillPop != null ? widget.onWillPop : () async => false,
            child: child,
          );
  }
}
