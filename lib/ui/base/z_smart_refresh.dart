import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// @author zdl
/// date 2020/11/9 16:42
/// email zdl328465042@163.com
/// description 刷新控件
class ZSmartRefresh extends StatelessWidget {
  final RefreshController controller;
  final Widget child;
  final bool showNoDataWidget;
  final String noDataMsg;
  final Widget noDataWidget;
  final String loadMoreNoDataText;
  final bool enableRefresh;
  final bool enableLoad;
  final Function onRefresh;
  final Function onLoad;
  final Color bgColor;
  final bool lightText;

  const ZSmartRefresh({
    @required this.controller,
    @required this.child,
    this.showNoDataWidget = false,
    this.noDataMsg = '暂无数据',
    this.noDataWidget,
    this.loadMoreNoDataText,
    this.enableRefresh = true,
    this.enableLoad = true,
    this.onRefresh,
    this.onLoad,
    this.bgColor,
    this.lightText = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget sr = SmartRefresher(
      controller: controller,
      child: showNoDataWidget
          ? (noDataWidget == null
              ? Center(child: Text(noDataMsg))
              : noDataWidget)
          : child,
      header: ClassicHeader(
        textStyle: TextStyle(color: lightText ? Colors.white70 : Colors.grey),
        failedIcon:
            Icon(Icons.error, color: lightText ? Colors.white70 : Colors.grey),
        completeIcon:
            Icon(Icons.done, color: lightText ? Colors.white70 : Colors.grey),
        idleIcon: Icon(Icons.arrow_downward,
            color: lightText ? Colors.white70 : Colors.grey),
        releaseIcon:
            Icon(Icons.refresh, color: lightText ? Colors.white70 : Colors.grey),
        refreshingIcon: SizedBox(
            width: 25.0,
            height: 25.0,
            child: const CupertinoActivityIndicator()),
        completeText: '加载完成',
        failedText: '加载失败',
        refreshingText: '下拉刷新',
        releaseText: '释放以刷新',
        idleText: '下拉刷新',
      ),
      footer: ClassicFooter(
        textStyle: TextStyle(color: lightText ? Colors.white70 : Colors.grey),
        failedIcon:
            Icon(Icons.error, color: lightText ? Colors.white70 : Colors.grey),
        canLoadingIcon: Icon(Icons.autorenew,
            color: lightText ? Colors.white70 : Colors.grey),
        idleIcon: Icon(Icons.arrow_upward,
            color: lightText ? Colors.white70 : Colors.grey),
        loadingIcon: SizedBox(
            width: 25.0,
            height: 25.0,
            child: const CupertinoActivityIndicator()),
        idleText: '上拉加载更多',
        canLoadingText: '释放以加载更多',
        failedText: '加载失败',
        loadingText: '加载中...',
        noDataText: loadMoreNoDataText ?? '没有更多数据了',
      ),
      enablePullDown: enableRefresh,
      enablePullUp: enableLoad,
      onRefresh: onRefresh,
      onLoading: onLoad,
    );
    return bgColor == null
        ? sr
        : Container(
            color: bgColor,
            child: sr,
          );
  }
}
