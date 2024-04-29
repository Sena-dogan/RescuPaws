import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user.freezed.dart';
part 'chat_user.g.dart';

@freezed
class ChatUserModel with _$ChatUserModel {
  factory ChatUserModel({
    required String senderID,
    required String senderEmail,
    required String receiverID,
    required String receiverEmail,
  }) = _ChatUserModel;

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => _$ChatUserModelFromJson(json);
}