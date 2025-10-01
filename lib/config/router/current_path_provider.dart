import 'package:go_router/go_router.dart'; // doğru import
import 'package:rescupaws/config/router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_path_provider.g.dart';

@riverpod
class CurrentPath extends _$CurrentPath {
  @override
  String? build() {
    GoRouter router = ref.watch(goRouteProvider);

    void listener() {
      state = router.state.path;
    }

    // Dinleyici ekle
    router.routeInformationProvider.addListener(listener);

    // Provider dispose olduğunda dinleyiciyi kaldır
    ref.onDispose(() {
      router.routeInformationProvider.removeListener(listener);
    });

    return router.state.path;
  }
}
