import 'copy/event_bus.dart';

class ZEventBusUtil<T>{
  final T data;

  const ZEventBusUtil(this.data);

  static final EventBus eventBus = new EventBus();

  static fire<T>(T data) {
    eventBus.fire(data);
  }

}