import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wechat/components/chatbub.dart';
import 'package:wechat/components/txtfield.dart';
import 'package:wechat/services/chat/chat_session.dart';

class ChatPage extends StatefulWidget {
  final String reciveruserEmail;
  final String reciverUserId;
  const ChatPage({
      super.key, 
      required this.reciverUserId, 
      required this.reciveruserEmail
      });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.reciverUserId, _messageController.text);
      // clear the controller after sending
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciveruserEmail),
      ),
      body: Column(children: [
        // messsages
        Expanded(child: _buildMessageList()),

        // new input
        _buildMessageInput(),
      ]
      ),
    );
  }

  // build msg list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatServices.getMessages(
            widget.reciverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  // build msg item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the msg to right for sender and left for reciver
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
           ? CrossAxisAlignment.end 
           : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
           ? MainAxisAlignment.end 
           : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            ChatBubble(message: data['message'])
          ],
        ),
      ),
    );
  }

  // build msg input
  Widget _buildMessageInput() {
    return Row(
      children: [
        // txtfield
        Expanded(
          child: Mytxtfield(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false),
        ),

        // send button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward_sharp,
            size: 40,
          ),
        ),
      ],
    );
  }
}
