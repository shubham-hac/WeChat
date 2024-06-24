import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wechat/model/message.dart';

class ChatServices extends ChangeNotifier {
  // instance of auth and store
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  // send (post)
  Future<void> sendMessage(String reciverId, String message) async {
    // get current user
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a msg
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      reciverId: reciverId,
      message: message,
      timestamp: timestamp,
    );

    // chat room id from current user to reciver id {sorted}
    List<String> ids = [currentUserId, reciverId];
    ids.sort(); // to make sure that the chat room remains same for any pairs of users
    String chatRoomId = ids.join("_"); // combining ids for chat room

    // add new msg to db
    await _firebaseStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //  Get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room for reciver end and also sort ids
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firebaseStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
