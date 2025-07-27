import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'private_chat_screen.dart';

class UserListScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start Private Chat")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs.where((doc) => doc.id != currentUser!.uid).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userData = user.data() as Map<String, dynamic>;
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(userData['name'] ?? "No Name"),
                onTap: () async {
                  String chatId = await _getOrCreateChat(user.id);
                  Get.to(() => PrivateChatScreen(
                        chatId: chatId,
                        receiverId: user.id,
                        receiverName: userData['name'] ?? "No Name",
                      ));
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<String> _getOrCreateChat(String otherUserId) async {
    final currentId = currentUser!.uid;
    final chatQuery = await FirebaseFirestore.instance
        .collection('private_chats')
        .where('users', arrayContains: currentId)
        .get();

    for (var doc in chatQuery.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(otherUserId)) return doc.id;
    }

    final newChat = await FirebaseFirestore.instance.collection('private_chats').add({
      'users': [currentId, otherUserId],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }
}
