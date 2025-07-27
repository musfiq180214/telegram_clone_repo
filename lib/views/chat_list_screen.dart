import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import '../controllers/chat_controller.dart';

class ChatListScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  void _showCreateChatDialog(BuildContext context) {
  final TextEditingController chatNameCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Create New Chat"),
      content: TextField(
        controller: chatNameCtrl,
        decoration: InputDecoration(hintText: "Enter chat name"),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text("Create"),
          onPressed: () async {
            final chatName = chatNameCtrl.text.trim();
            if (chatName.isNotEmpty) {
              await chatController.firestore.collection('chats').add({
                'chatName': chatName,
                'createdAt': FieldValue.serverTimestamp(),
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatController.firestore.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return Center(child: Text('No chats yet'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final chatId = chat.id;
              // Assuming you store chat metadata, e.g. 'chatName' or participants, you can show here
              final chatName = chat['chatName'] ?? 'Chat $index';

              return ListTile(
                title: Text(chatName),
                onTap: () {
                  Get.to(() => ChatScreen(chatId: chatId));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
  child: Icon(Icons.add),
  onPressed: () {
    _showCreateChatDialog(context);
  },
),

    );
  }
}
