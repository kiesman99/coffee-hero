import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerStateNotifier extends StateNotifier<Duration> {
  TimerStateNotifier() : super(Duration.zero);

  late Timer _timer;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state += const Duration(seconds: 1);
    });
  }

  void stop() {
    _timer.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }
}

final timerStateProvider = StateNotifierProvider.autoDispose<TimerStateNotifier, Duration>((ref) {
  return TimerStateNotifier();
});