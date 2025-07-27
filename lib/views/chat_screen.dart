import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final String chatId; // for now, just a string id representing a chat

  ChatScreen({required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.put(ChatController());
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController messageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatController.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final currentUser = authController.user.value;
                    final isMe = currentUser != null && message.senderId == currentUser.uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageCtrl,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final text = messageCtrl.text.trim();
                    if (text.isNotEmpty) {
                      final msg = Message(
                        id: '',
                        senderId: authController.user.value!.uid,
                        text: text,
                        timestamp: DateTime.now(),
                      );

                      final uid = authController.user.value?.uid;
                      if (uid == null) {
                        print("❌ Current user UID is null.");
                        return;
                        }


                      print("⏳ Sending message: ${msg.toMap()}");
                      
                      await chatController.sendMessage(widget.chatId, msg);
                      messageCtrl.clear();
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
