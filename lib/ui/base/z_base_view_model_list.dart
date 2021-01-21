import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'z_base_view_model.dart';

abstract class ZBaseViewModelList<T> extends ZBaseViewModel {
  static const int pageNumFirst = 1;
  final int pageSize = 20;
  int _currentPageNum = pageNumFirst;

  List<T> data = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  // 下拉刷新
  refresh({
    ValueChanged<List<T>> onSuccess,
    ValueChanged<List<T>> onCache,
    ValueChanged<String> onError,
  }) async {
    setBusy();
    bool hasMoreData = (hasMore() == true);
    if (hasMoreData) _currentPageNum = pageNumFirst;
    try {
      loadData(
          pageIndex: hasMoreData ? _currentPageNum : null,
          onSuccess: (data) {
            _setData(data);
            if (null != onSuccess) {
              onSuccess(data);
            }
          },
          onCache: (data) {
            if (null != onCache) {
              _setData(data, loadData: false);
              onCache(data);
            }
          },
          onError: (data) {
            if (null != onError) {
              onError(data);
            }
            setIdle();
          });
    } catch (e, s) {
//      if (init) list.clear();
//      setError(e, s);
      setIdle();
    }
  }

  void _setData(List<T> data, {bool loadData = true}) {
    if (data.isEmpty) {
      refreshController.refreshCompleted(resetFooterState: true);
      this.data.clear();
      if (loadData == true) {
        setEmpty();
      }
    } else {
//      onCompleted(data);
      this.data.clear();
      this.data.addAll(data);
      refreshController.refreshCompleted();
      // 小于分页的数量,禁止上拉加载更多
      if (data.length < pageSize) {
        refreshController.loadNoData();
      } else {
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
      }
      if (loadData == true) {
        setIdle();
      }
    }
  }

  /// 上拉加载更多
  loadMore({
    ValueChanged<List<T>> onSuccess,
    ValueChanged<List<T>> onCache,
    ValueChanged<String> onError,
  }) async {
    try {
      loadData(
          pageIndex: ++_currentPageNum,
          onSuccess: (data) {
            _setMoreData(data);
            if (null != onSuccess) {
              onSuccess(data);
            }
          },
          onCache: (data) {
            if (null != onCache) {
              _setMoreData(data);
              onCache(data);
            }
          },
          onError: (data) {
            _currentPageNum--;
            refreshController.loadFailed();
            if (null != onError) {
              onError(data);
            }
          });
    } catch (e, s) {
      _currentPageNum--;
      refreshController.loadFailed();
      debugPrint('error--->\n' + e.toString());
      debugPrint('statck--->\n' + s.toString());
      return null;
    }
  }

  void _setMoreData(List<T> data) {
    if (data.isEmpty) {
      _currentPageNum--;
      refreshController.loadNoData();
    } else {
      //          onCompleted(data);
      this.data.addAll(data);
      if (data.length < pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      notifyListeners();
    }
  }

  /// 加载数据
  loadData({
    int pageIndex,
    ValueChanged<List<T>> onSuccess,
    ValueChanged<List<T>> onCache,
    ValueChanged<String> onError,
  });

  ///有上拉加载更多
  bool hasMore() => true;

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
