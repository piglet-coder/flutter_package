import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/11/6 16:36
/// email zdl328465042@163.com
/// description BaseViewModel
enum ViewState {
  idle, //空闲
  busy, //加载中
  empty, //无数据
  error, //加载失败
}

class ZBaseViewModel with ChangeNotifier {
  bool _disposed = false;
  ViewState _viewState;
  BuildContext context;
  bool autoLoadData;

  ZBaseViewModel({ViewState viewState, BuildContext context}) {
    _viewState = (viewState ?? ViewState.idle);
    context = context;
    debugPrint('ZBaseViewModel---constructor--->$runtimeType');
  }

  ViewState get viewState => _viewState;

  bool get isBusy => viewState == ViewState.busy;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  setBuildContext(BuildContext context) {
    this.context = context;
  }

  set viewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  void setIdle() {
    viewState = ViewState.idle;
  }

  void setBusy() {
    viewState = ViewState.busy;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  void setError() {
    viewState = ViewState.error;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    debugPrint('ZBaseViewModel dispose -->$runtimeType');
    super.dispose();
  }

  void initState() {}
}
