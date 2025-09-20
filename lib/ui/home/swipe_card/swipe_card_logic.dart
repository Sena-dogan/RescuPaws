import 'package:rescupaws/data/enums/detail_enums.dart';
import 'package:rescupaws/ui/home/swipe_card/swipe_card_ui_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'swipe_card_logic.g.dart';

@riverpod
class SwipeCardLogic extends _$SwipeCardLogic {
  @override
  SwipeCardUiModel build() {
    return SwipeCardUiModel();
  }

  void setId(int id) {
    state = state.copyWith(id: id, selectedImageIndex: 0);
  }

  void setTap(Direction direction) {
    if (direction == Direction.Left) {
      state = state.copyWith(selectedImageIndex: state.selectedImageIndex - 1);
    } else if (direction == Direction.Right) {
      state = state.copyWith(selectedImageIndex: state.selectedImageIndex + 1);
    }
  }
}
