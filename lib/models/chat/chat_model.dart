import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_data.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
abstract class Chat with _$Chat {
  factory Chat({
    required String name,
    required String profilePic,
    required String userId,
    required DateTime time,
    required String message,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

extension ChatExtension on Chat {
  UserData toUserData() {
    return UserData(
      uid: userId,
      email: '', // Provide email if available
      displayName: name,
      photoUrl: profilePic,
    );
  }
}
