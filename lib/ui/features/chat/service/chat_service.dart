import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/chat/message.dart';
import '../../../../models/meta_data.dart';
import '../../../../models/user_data.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns a stream of users as a list of maps.
  ///
  /// The stream emits a new list of users whenever there is a change in the data.
  /// Each user is represented as a map with string keys and dynamic values.
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _db.collection('Users').snapshots().map(
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

  Future<void> addOrUpdateUser(UserData userData) async {
    userData = userData.minify();
    await _db.collection('Users').doc(userData.uid).set(userData.minify().toJson());
  }

  Future<UserData> getUserById(String userId) async {
    final DocumentSnapshot docSnapshot =
        await _db.collection('Users').doc(userId).get();
    if (docSnapshot.exists) {
      return UserData.fromJson(docSnapshot.data()! as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  /// Sends a message.
  ///
  /// This method is responsible for sending a message to the chat service.
  /// It takes no parameters and returns a [Future] that completes when the
  /// message has been sent successfully.
  Future<void> sendMessage(
      String receiverId, String message, UserData? receiverUser) async {
    if (receiverUser == null) {
      throw Exception('Receiver user not found');
    }
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

    final UserData currentUser = _auth.currentUser!.toUserData();

    // Add the message to the database.
    await _db
        .collection('Messages')
        .doc(currentUserId)
        .collection(receiverId)
        .add(newMessage.toJson());

    await addOrUpdateUser(currentUser);
    await addOrUpdateUser(receiverUser);
  }

  /// Retrieves a stream of messages for a given receiver ID.
  ///
  /// The [receiverId] parameter specifies the ID of the message receiver.
  /// Returns a [Stream] that emits a list of [MessageModel] objects.
  Stream<List<MessageModel>> getMessages(String receiverId) {
    // Get current user's information.
    final String currentUserId = _auth.currentUser!.uid;

    // Get messages from the database.
    return _db
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

  Stream<QuerySnapshot> getMessagesStream() {
    final String currentUserId = _auth.currentUser!.uid;
    return _db
        .collection('Messages')
        .doc(currentUserId)
        .collection(currentUserId)
        .snapshots();
  }

  Stream<Set<String>> getMessagedUsersStream() {
    return getMessagesStream().map((QuerySnapshot<Object?> snapshot) {
      final Set<String> receiverIds = <String>{};
      for (final QueryDocumentSnapshot<Object?> doc in snapshot.docs) {
        receiverIds.add(doc.id); // Assuming doc.id is the receiver's ID
      }
      return receiverIds;
    });
  }
}

extension on User {
  UserData toUserData() {
    return UserData(
      uid: uid,
      email: email,
      displayName: displayName,
      disabled: false,
      emailVerified: emailVerified,
      photoUrl: photoURL,
      phoneNumber: phoneNumber,
    );
  }
}


extension on UserData {
  UserData minify() {
    return UserData(
      uid: uid,
      email: email,
      emailVerified: emailVerified,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
      disabled: disabled,
    );
  }
}