import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'global_event_bus.dart';

part 'global_event_bus_provider.g.dart';

@Riverpod(keepAlive: true)
GlobalEventBus globalEventBus(Ref ref) {
  final bus = GlobalEventBus();

  ref.onDispose(bus.dispose);
  return bus;
}
