import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_package/flutter_package.dart';

/// @author zdl
/// date 2021/04/08 15:04
/// email zdl328465042@163.com
/// description 条件选择器
///
/// 若需要联动，data类型为List<PickerItem>，响应联动值通过PickerItem中children传入
/// 若不需要联动，data类型为List<List<PickerItem>>，此时不会去取PickerItem中的children
class ZOptionPicker {
  const ZOptionPicker._();

  static show(
    BuildContext context, {
    @required double itemExtent,
    @required List<dynamic> data,
    int maxShowCount = 5,
    PickerConfirmCallback onConfirm,
    TextStyle itemStyle,
    dynamic title,
    dynamic cancel,
    dynamic confirm,
  }) {
    assert(data?.isNotEmpty == true, 'data不可为null');
    assert(data.first is PickerItem || data.first is List, 'data类型只可为PickerItem或者List<PickerItem>');
    showModalBottomSheet<void>(
        context: context,
        enableDrag: false,
        builder: (BuildContext context) {
          return _PickerUi(
            itemExtent,
            maxShowCount,
            data,
            onConfirm,
            itemStyle,
            title,
            cancel,
            confirm,
          );
        });
  }
}

class _PickerUi extends StatefulWidget {
  final double itemExtent;
  final int maxShowCount;
  final List<dynamic> data;
  final PickerConfirmCallback onConfirm;
  final TextStyle itemStyle;
  final dynamic title;
  final dynamic cancel;
  final dynamic confirm;

  const _PickerUi(
    this.itemExtent,
    this.maxShowCount,
    this.data,
    this.onConfirm,
    this.itemStyle,
    this.title,
    this.cancel,
    this.confirm,
  );

  @override
  __PickerUiState createState() => __PickerUiState();
}

class __PickerUiState extends State<_PickerUi> {
  bool _isLink = false;
  int _maxLevel = -1;
  List<List<PickerItem>> _dataList;
  List<FixedExtentScrollController> _ctrlList;
  List<int> _selects;

  @override
  void initState() {
    super.initState();
    //若data中类型为PickerItem则为联动，反之则为相互独立
    _isLink = widget.data.first is PickerItem;
    _getMaxLevel(widget.data, 1);
    _dataList = List(_maxLevel);
    _ctrlList = List(_maxLevel);
    _selects = List(_maxLevel);
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < _maxLevel; i++) {
      children.add(_item(i));
    }
    return Container(
      height: widget.itemExtent * (widget.maxShowCount + 1),
      color: Colors.white,
      child: Column(
        children: [
          _header(),
          Expanded(
            child: Row(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    TextStyle defStyle = TextStyle(
      color: Colors.blue,
      fontSize: 28.toFit(),
    );
    Widget cancelWidget;
    Widget titleWidget;
    Widget confirmWidget;
    if (widget.cancel is String) {
      cancelWidget = Text(widget.cancel, style: defStyle);
    } else if (widget.cancel is Widget) {
      cancelWidget = widget.cancel;
    } else {
      cancelWidget = Text('取消', style: defStyle);
    }
    if (widget.title is String) {
      titleWidget = Text(widget.title, style: defStyle);
    } else if (widget.title is Widget) {
      titleWidget = widget.title;
    } else {
      titleWidget = SizedBox();
    }
    if (widget.confirm is String) {
      confirmWidget = Text(widget.confirm, style: defStyle);
    } else if (widget.confirm is Widget) {
      confirmWidget = widget.confirm;
    } else {
      confirmWidget = Text('确定', style: defStyle);
    }
    return Container(
      height: widget.itemExtent,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.toFit()),
      alignment: Alignment.center,
      child: Row(
        children: [
          InkWell(
            onTap: () => ZIntentUtil.finish(context),
            child: cancelWidget,
          ),
          Expanded(child: Center(child: titleWidget)),
          InkWell(
            onTap: () {
              if (widget.onConfirm != null) widget.onConfirm(_selects);
              ZIntentUtil.finish(context);
            },
            child: confirmWidget,
          ),
        ],
      ),
    );
  }

  Widget _item(int column) {
    List<PickerItem> data = _dataList[column] ?? [];
    return data.isEmpty
        ? Spacer()
        : Expanded(
            child: CupertinoPicker(
              itemExtent: widget.itemExtent,
              scrollController: _ctrlList[column],
              children: data.map((e) => Center(child: Text(e.text, style: widget.itemStyle,))).toList(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _changeData(column, index);
                });
              },
            ),
          );
  }

  void _getMaxLevel(List data, int level) {
    if (data?.isNotEmpty != true) return;
    if (_isLink) {
      //列表联动
      for (PickerItem item in data) {
        if (item.children?.isNotEmpty == true) {
          _getMaxLevel(item.children, level + 1);
        }
      }
      if (_maxLevel < level) _maxLevel = level;
    } else {
      //列表相互独立
      _maxLevel = data.length;
    }
  }

  void _initData() {
    for (int i = 0; i < _maxLevel; i++) {
      _ctrlList[i] = FixedExtentScrollController();
      if (_isLink) {
        if (i == 0) {
          _dataList[i] = widget.data;
        } else {
          var upLevel = _dataList[i - 1];
          _dataList[i] = upLevel?.isNotEmpty == true ? upLevel[0]?.children : null;
        }
      } else {
        _dataList[i] = widget.data[i] as List<PickerItem>;
      }
      //选中一定要在初始化数据过后赋值，不然第一次进入默认选择全为null
      _selects[i] = _dataList[i] == null ? null : 0;
    }
  }

  void _changeData(int column, int index) {
    _selects[column] = index;
    //若是联动，则需要计算子列表变动
    if (_isLink) {
      //滑动最后一列，不用重新计算数据
      if (column == _maxLevel - 1) return;
      //计算滑动后面列的数据
      for (int i = column + 1; i < _maxLevel; i++) {
        var upLevel = _dataList[i - 1];
        if (i == column + 1) {
          _dataList[i] = upLevel[index]?.children;
        } else {
          _dataList[i] = upLevel?.isNotEmpty == true ? upLevel[0]?.children : null;
        }
        _selects[i] = _dataList[i] == null ? null : 0;
        //联动相关数据全部滑到第一条
        if (_dataList[i]?.isNotEmpty == true) _ctrlList[i].jumpToItem(0);
      }
    }
  }
}

typedef PickerConfirmCallback = void Function(List<int> selecteds);

class PickerItem<T> {
  /// 显示内容
  String text;

  /// 数据值
  T value;

  /// 子项
  List<PickerItem<T>> children;

  PickerItem({this.text, this.value, this.children});

  @override
  String toString() {
    return 'PickerItem{text: $text, value: $value, children: $children}';
  }
}
