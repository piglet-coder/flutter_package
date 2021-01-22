import 'copy/event_bus.dart';

/// @author zdl
/// date 2021/1/22 18:15
/// email zdl328465042@163.com
/// description EventBus工具类
class ZEventBusUtil<T>{
  final T data;

  const ZEventBusUtil(this.data);

  static final EventBus eventBus = new EventBus();

  static fire<T>(T data) {
    eventBus.fire(data);
  }
}