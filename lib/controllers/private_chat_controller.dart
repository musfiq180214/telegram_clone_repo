// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class PrivateChatController extends GetxController {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   User? get currentUser => auth.currentUser;

//   Stream<QuerySnapshot> getMessagesStream(String chatId) {
//     return firestore
//         .collection('private_chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }

//   Future<void> sendMessage(String chatId, String text) async {
//     final userId = currentUser?.uid;
//     if (userId == null) return;

//     final messageData = {
//       'senderId': userId,
//       'message': text,
//       'timestamp': FieldValue.serverTimestamp(),
//       'isSeen': false,
//     };

//     final messagesRef = firestore.collection('private_chats').doc(chatId).collection('messages');
//     await messagesRef.add(messageData);

//     await firestore.collection('private_chats').doc(chatId).update({
//       'lastMessage': text,
//       'lastMessageTime': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> markMessagesAsSeen(String chatId, String receiverId) async {
//     final userId = currentUser?.uid;
//     if (userId == null) return;

//     final messagesRef = firestore.collection('private_chats').doc(chatId).collection('messages');

//     final unseenMessagesQuery = await messagesRef
//         .where('senderId', isEqualTo: receiverId)
//         .where('isSeen', isEqualTo: false)
//         .get();

//     final batch = firestore.batch();

//     for (var doc in unseenMessagesQuery.docs) {
//       batch.update(doc.reference, {'isSeen': true});
//     }

//     await batch.commit();
//   }

//   // Typing indicator methods:

//   Future<void> updateTypingStatus(String chatId, bool isTyping) async {
//     final userId = currentUser?.uid;
//     if (userId == null) return;

//     final typingDoc = firestore.collection('private_chats').doc(chatId).collection('typing_status').doc(userId);

//     await typingDoc.set({'isTyping': isTyping});
//   }

//   Stream<Map<String, bool>> typingStatusStream(String chatId) {
//     return firestore
//         .collection('private_chats')
//         .doc(chatId)
//         .collection('typing_status')
//         .snapshots()
//         .map((snapshot) {
//       final Map<String, bool> typingMap = {};
//       for (var doc in snapshot.docs) {
//         typingMap[doc.id] = doc['isTyping'] ?? false;
//       }
//       return typingMap;
//     });
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PrivateChatController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return firestore
        .collection('private_chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(String chatId, String text) async {
    final userId = currentUser?.uid;
    if (userId == null) return;

    final messageData = {
      'senderId': userId,
      'message': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isSeen': false,
    };

    final messagesRef = firestore.collection('private_chats').doc(chatId).collection('messages');
    await messagesRef.add(messageData);

    await firestore.collection('private_chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markMessagesAsSeen(String chatId, String receiverId) async {
    final userId = currentUser?.uid;
    if (userId == null) return;

    final messagesRef = firestore.collection('private_chats').doc(chatId).collection('messages');

    final unseenMessagesQuery = await messagesRef
        .where('senderId', isEqualTo: receiverId)
        .where('isSeen', isEqualTo: false)
        .get();

    final batch = firestore.batch();

    for (var doc in unseenMessagesQuery.docs) {
      batch.update(doc.reference, {'isSeen': true});
    }

    await batch.commit();
  }

  // Typing indicator methods:

  Future<void> updateTypingStatus(String chatId, bool isTyping) async {
    final userId = currentUser?.uid;
    if (userId == null) return;

    final typingDoc = firestore.collection('private_chats').doc(chatId).collection('typing_status').doc(userId);

    await typingDoc.set({'isTyping': isTyping});
  }

  Stream<Map<String, bool>> typingStatusStream(String chatId) {
    return firestore
        .collection('private_chats')
        .doc(chatId)
        .collection('typing_status')
        .snapshots()
        .map((snapshot) {
      final Map<String, bool> typingMap = {};
      for (var doc in snapshot.docs) {
        typingMap[doc.id] = doc['isTyping'] ?? false;
      }
      return typingMap;
    });
  }
}
