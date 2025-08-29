import 'dart:async';

import 'package:riverpod/src/framework.dart';

extension CacheForExtension on Ref {
  /// Keeps the provider alive for [duration].
  void cacheFor(Duration duration) {
    // Immediately prevent the state from getting destroyed.
    final KeepAliveLink link = keepAlive();
    // After duration has elapsed, we re-enable automatic disposal.
    final Timer timer = Timer(duration, link.close);

    // Optional: when the provider is disposed, cancel the timer.
    onDispose(timer.cancel);
  }
}
