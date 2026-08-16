import 'dart:async';

import 'global_event.dart';

class GlobalEventBus {
  final _controller = StreamController<GlobalEvent>.broadcast();

  Stream<GlobalEvent> get stream => _controller.stream;

  void add(GlobalEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
