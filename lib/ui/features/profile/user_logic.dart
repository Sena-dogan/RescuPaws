import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/network/user/user_repository.dart' as user_repo;
import 'user_ui_model.dart';

part 'user_logic.g.dart';

@riverpod
class UserLogic extends _$UserLogic {
  @override
  UserUiModel build() {
    return UserUiModel(
      user: FirebaseAuth.instance.currentUser,
    );
  }

  bool updateUserImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((XFile? picked) async {
      if (picked == null) return;
      try {
        setImageLoading(isLoading: true);
        final User? user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        // User-scoped storage path: users/{uid}/profile/{timestamp}.jpg
        final String fileName =
            'users/${user.uid}/profile/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference refStorage =
            FirebaseStorage.instance.ref().child(fileName);

        await refStorage.putData(await picked.readAsBytes());
        final String downloadUrl = await refStorage.getDownloadURL();

        // Update FirebaseAuth profile photoURL
        await user.updatePhotoURL(downloadUrl);
        await user.reload();

        // Update local state
        setUser();

        // Sync Firestore users/{uid}
        await ref
            .read(user_repo.getUserRepositoryProvider)
            .upsertCurrentUser();
      } finally {
        setImageLoading();
      }
    });
    setImageLoading();
    return true;
  }

  void setImageLoading({bool isLoading = false}) {
    state = state.copyWith(isImageLoading: isLoading);
  }

  void setLoading({bool isLoading = true}) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setUser({bool isLoading = false}) {
    state = state.copyWith(
        isImageLoading: isLoading, user: FirebaseAuth.instance.currentUser);
    // Keep Firestore users/{uid} in sync with FirebaseAuth
    ref.read(user_repo.getUserRepositoryProvider).upsertCurrentUser();
  }

  /// Manually sync current FirebaseAuth user into Firestore 'users' collection.
  Future<void> syncUserProfile() async {
    await ref
        .read(user_repo.getUserRepositoryProvider)
        .upsertCurrentUser();
  }
}
