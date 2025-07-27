import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'private_chat_screen.dart';

class UserListScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String getChatId(String userId1, String userId2) {
    return (userId1.compareTo(userId2) < 0)
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  Future<void> startPrivateChat(String otherUserId, String otherUserName) async {
    final currentUserId = auth.currentUser!.uid;
    final chatId = getChatId(currentUserId, otherUserId);

    final chatRef = firestore.collection('private_chats').doc(chatId);

    final doc = await chatRef.get();
    if (!doc.exists) {
      await chatRef.set({
        'participants': [currentUserId, otherUserId],
        'lastMessage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    // Navigate to private chat screen
//     Get.to(() => PrivateChatScreen(
//   chatId: chatId,
//   receiverId: otherUserId, // ✅ only receiverId and chatId are expected
//   receiverName: otherUserName, // Optional: you can pass the name if available
// ));
  
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Select User to Chat")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs.where((doc) => doc.id != currentUserId).toList();

          if (users.isEmpty) return Center(child: Text("No other users found"));

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userName = user['name'];
              final userId = user.id;

              return ListTile(
                title: Text(userName),
                subtitle: Text(user['email']),
                onTap: () => startPrivateChat(userId, userName),
              );
            },
          );
        },
      ),
    );
  }
}
