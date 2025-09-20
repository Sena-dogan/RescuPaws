import 'package:rescupaws/states/widgets/bottom_nav_bar/nav_bar_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nav_bar_logic.g.dart';

@riverpod
class BottomNavBarLogic extends _$BottomNavBarLogic {
  @override
  BottomNavBarUiModel build() {
    return const BottomNavBarUiModel();
  }

  void setNavIndex(int index) {
    if (ref.mounted) state = state.copyWith(navIndex: index);
  }
}
