import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/enums/message_type.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class MessageModel with _$MessageModel {
  factory MessageModel({
    required String senderID,
    required String receiverID,
    required String messageID,
    required bool isSeen,
    required String lastMessage,
    required MessageType messageType,
    required DateTime time,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
