import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'z_base_view_model.dart';

/// @author zdl
/// date 2020/11/6 16:36
/// email zdl328465042@163.com
/// description Provider封装类
class ZProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final ValueWidgetBuilder<T> builder;
  final Widget child;
  final Function(T model) onModelReady;
  final bool autoDispose;
  final bool autoInitState;
  final bool autoLoadData;
  final Function initState;
  final Function dispose;

  const ZProvider({
    Key key,
    @required this.model,
    @required this.builder,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
    this.autoInitState: true,
    this.autoLoadData: true,
    this.initState,
    this.dispose,
  }) : super(key: key);

  @override
  _ZProviderState<T> createState() => _ZProviderState<T>();
}

class _ZProviderState<T extends ChangeNotifier> extends State<ZProvider<T>> {
  T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();

    if (model is ZBaseViewModel) {
      ZBaseViewModel mModel = model as ZBaseViewModel;
      mModel.setBuildContext(context);
      mModel.autoLoadData = widget.autoLoadData ?? false;
      if (widget.autoInitState == true) {
        mModel.initState();
      }
    }
    if (null != widget.initState) {
      widget.initState.call();
    }
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
    if (null != widget.dispose) {
      widget.dispose.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (model is ZBaseViewModel) {
      (model as ZBaseViewModel).setBuildContext(context);
    }
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
