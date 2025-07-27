import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String chatId, Message message) async {
  try {
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
    print("✅ Message sent");
  } catch (e) {
    print("❌ Failed to send message: $e");
    Get.snackbar("Error", e.toString());
  }
}


  // Get messages stream
  Stream<List<Message>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Message.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}
