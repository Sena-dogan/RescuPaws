import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class MessageModel with _$MessageModel {
  factory MessageModel({
    required String senderID,
    required String senderEmail,
    required String receiverID,
    required String message,
    @TimestampConverter() required Timestamp timestamp,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
}

class TimestampConverter implements JsonConverter<Timestamp, Object> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Object json) {
    return Timestamp.fromMicrosecondsSinceEpoch(json as int);
  }

  @override
  Object toJson(Timestamp object) {
    return object.microsecondsSinceEpoch;
  }
}
