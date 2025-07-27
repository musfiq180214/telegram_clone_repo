import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrivateChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Generate chatId consistently from two UIDs
  String getChatId(String userId1, String userId2) {
    return (userId1.compareTo(userId2) < 0)
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  // Create chat if not exists
  Future<String> createOrGetChat(String otherUserId) async {
    final currentId = currentUser!.uid;
    final chatId = getChatId(currentId, otherUserId);

    final doc = await _firestore.collection('private_chats').doc(chatId).get();

    if (!doc.exists) {
      await _firestore.collection('private_chats').doc(chatId).set({
        'participants': [currentId, otherUserId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

  // Send a message
  Future<void> sendMessage(String chatId, String message) async {
    if (currentUser == null || message.trim().isEmpty) return;

    final messageData = {
      'senderId': currentUser!.uid,
      'message': message.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'isSeen': false,
    };

    await _firestore
        .collection('private_chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    await _firestore.collection('private_chats').doc(chatId).update({
      'lastMessage': message.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Mark all unseen messages as seen for current user in this chat
  Future<void> markMessagesAsSeen(String chatId, String otherUserId) async {
    if (currentUser == null) return;

    final messagesRef =
        _firestore.collection('private_chats').doc(chatId).collection('messages');

    // Query messages sent by other user where isSeen == false
    final unseenMessagesQuery = await messagesRef
        .where('senderId', isEqualTo: otherUserId)
        .where('isSeen', isEqualTo: false)
        .get();

    if (unseenMessagesQuery.docs.isEmpty) return;

    final batch = _firestore.batch();

    for (var doc in unseenMessagesQuery.docs) {
      batch.update(doc.reference, {'isSeen': true});
    }

    await batch.commit();
  }

  // Stream messages ordered by timestamp
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _firestore
        .collection('private_chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }
}
