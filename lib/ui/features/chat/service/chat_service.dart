import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/chat/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns a stream of users as a list of maps.
  ///
  /// The stream emits a new list of users whenever there is a change in the data.
  /// Each user is represented as a map with string keys and dynamic values.
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            final Map<String, dynamic> user = doc.data();
            return user;
          },
        ).toList();
      },
    );
  }

  /// Sends a message.
  ///
  /// This method is responsible for sending a message to the chat service.
  /// It takes no parameters and returns a [Future] that completes when the
  /// message has been sent successfully.
  Future<void> sendMessage(String receiverId, String message) async {
    // Get current user's information.
    final String currentUserId = _auth.currentUser!.uid;
    final String curretUserEmail = _auth.currentUser!.email!;
    final Timestamp timeStamp = Timestamp.now();

    // Create a new message.
    final MessageModel newMessage = MessageModel(
      senderID: currentUserId,
      senderEmail: curretUserEmail,
      receiverID: receiverId,
      message: message,
      timestamp: timeStamp,
    );

    // Add the message to the database.
    await _firestore
        .collection('Messages')
        .doc(currentUserId)
        .collection(receiverId)
        .add(newMessage.toJson());
  }

  /// Retrieves a stream of messages for a given receiver ID.
  ///
  /// The [receiverId] parameter specifies the ID of the message receiver.
  /// Returns a [Stream] that emits a list of [MessageModel] objects.
  Stream<List<MessageModel>> getMessages(String receiverId) {
    // Get current user's information.
    final String currentUserId = _auth.currentUser!.uid;

    // Get messages from the database.
    return _firestore
        .collection('Messages')
        .doc(currentUserId)
        .collection(receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            final Map<String, dynamic> data = doc.data();
            return MessageModel.fromJson(data);
          },
        ).toList();
      },
    );
  }

  /// get messaged users list from firestore
  Stream<QuerySnapshot> getMessagedUsers() {
    final String currentUserId = _auth.currentUser!.uid;
    debugPrint('Current User ID: $currentUserId');
    final Query<Map<String, dynamic>> receiversGroup =
        FirebaseFirestore.instance.collectionGroup(currentUserId);
    debugPrint('Receivers Group: $receiversGroup');

    return receiversGroup.snapshots();
  }
}
