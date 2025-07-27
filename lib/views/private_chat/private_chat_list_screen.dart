import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'private_chat_screen.dart';

class PrivateChatListScreen extends StatelessWidget {
  const PrivateChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Recent Chats")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('private_chats')
            .where('participants', arrayContains: currentUser!.uid)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text("No recent chats"));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data = chats[index].data()! as Map<String, dynamic>;
              final chatId = chats[index].id;
              final otherUserId = (data['participants'] as List).firstWhere((id) => id != currentUser!.uid);
              final lastMessage = data['lastMessage'] ?? '';
              final lastMessageStatus = data['lastMessageStatus'] ?? 'sent';
              final timestamp = data['lastMessageTime'] as Timestamp?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) return const SizedBox();
                  final userData = userSnapshot.data!.data()! as Map<String, dynamic>;

                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(userData['name'] ?? 'No Name'),
                    subtitle: Text("$lastMessage (${lastMessageStatus.toUpperCase()})"),
                    trailing: Text(
                      timestamp != null
                          ? TimeOfDay.fromDateTime(timestamp.toDate()).format(context)
                          : '',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrivateChatScreen(
                            chatId: chatId,
                            receiverId: otherUserId,
                            receiverName: userData['name'] ?? 'No Name',
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
