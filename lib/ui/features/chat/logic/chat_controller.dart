// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../models/chat/chat_model.dart';
// import '../../../../models/chat/message.dart';
// import '../../../../models/user_data.dart';
// import '../service/chat_repository.dart';
// import 'current_user_provider.dart';

// final Provider<ChatController> chatControllerProvider =
//     Provider<ChatController>(
//   (ProviderRef<ChatController> ref) {
//     final ChatRepository chatRepository = ref.watch(chatRepositoryProvider);
//     return ChatController(chatRepository: chatRepository, ref: ref);
//   },
// );

// class ChatController {
//   ChatController({
//     required ChatRepository chatRepository,
//     required ProviderRef<ChatController> ref,
//   })  : _chatRepository = chatRepository,
//         _ref = ref;

//   final ChatRepository _chatRepository;
//   final ProviderRef<ChatController> _ref;

//   Future<void> sendTextMessage(
//     BuildContext context, {
//     required String lastMessage,
//     required String receiverUserId,
//   }) async {
//     final UserData senderUser = _ref.watch(currentUserProvider!);

//     await _chatRepository.sendTextMessage(
//       context,
//       lastMessage: lastMessage,
//       receiverUserId: receiverUserId,
//       senderUser: senderUser,
//     );
//   }

//   Stream<List<Chat>> getChatsList() {
//     final UserData senderUser = _ref.watch(currentUserProvider!);
//     return _chatRepository.getChatsList(
//         senderUserId: senderUser.uid ?? 'Sender User Id is null');
//   }

//   /// invoke to get single chat (messages)
//   Stream<List<MessageModel>> getMessagesList({required String receiverUserId}) {
//     final UserData senderUser = _ref.watch(currentUserProvider!);
//     return _chatRepository.getMessagesList(
//       senderUserId: senderUser.uid ?? 'Sender User Id is null',
//       receiverUserId: receiverUserId,
//     );
//   }

//   Future<void> setChatMessageSeen(
//     BuildContext context, {
//     required String receiverUserId,
//     required String messageId,
//   }) async {
//     final UserData user = _ref.watch(currentUserProvider!);
//     await _chatRepository.setChatMessageSeen(
//       context,
//       receiverUserId: receiverUserId,
//       senderUserId: user.uid ?? 'Sender User Id is null',
//       messageId: messageId,
//     );
//   }
// }
