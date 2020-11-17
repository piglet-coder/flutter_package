import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'z_base_view_model.dart';

abstract class ZBaseViewModelRefresh<T> extends ZBaseViewModel {
  T data;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  // 下拉刷新
  refresh({
    ValueChanged<T> onSuccess,
    ValueChanged<T> onCache,
    ValueChanged<String> onError,
  }) async {
    setBusy();
    try {
      loadData(onSuccess: (data) {
        _setData(data);
        if (null != onSuccess) {
          onSuccess(data);
        }
        _refreshController.refreshCompleted();
      }, onCache: (data) {
        if (null != onCache) {
          _setData(data, loadData: false);
          onCache(data);
        }
      }, onError: (data) {
        if (null != onError) {
          onError(data);
        }
        _refreshController.refreshCompleted();
      });
    } catch (e, s) {
//      if (init) list.clear();
//      setError(e, s);
    }
  }

  void _setData(T data, {bool loadData = true}) {
    this.data = data;
    if (data == null) {
      if (loadData == true) {
        setEmpty();
      }
    } else {
      if (loadData == true) {
        setIdle();
      }
    }
  }

  // 加载数据
  loadData({
    ValueChanged<T> onSuccess,
    ValueChanged<T> onCache,
    ValueChanged<String> onError,
  });

  @override
  void initState() {
    super.initState();
    if (autoLoadData == true) {
      refresh();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
