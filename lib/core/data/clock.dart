import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simulated clock: real time + offset. Features read time only from here.
final clockProvider = NotifierProvider<ClockNotifier, DateTime>(ClockNotifier.new);

class ClockNotifier extends Notifier<DateTime> {
  Duration _offset = Duration.zero;

  @override
  DateTime build() {
    final timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    ref.onDispose(timer.cancel);
    return DateTime.now().add(_offset);
  }

  void advance(Duration by) {
    _offset += by;
    _tick();
  }

  void reset() {
    _offset = Duration.zero;
    _tick();
  }

  void _tick() => state = DateTime.now().add(_offset);
}
