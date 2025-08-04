// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../controllers/private_chat_controller.dart';

// class PrivateChatScreen extends StatefulWidget {
//   final String chatId;
//   final String receiverId;
//   final String receiverName;

//   const PrivateChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.receiverId,
//     required this.receiverName,
//   }) : super(key: key);

//   @override
//   State<PrivateChatScreen> createState() => _PrivateChatScreenState();
// }

// class _PrivateChatScreenState extends State<PrivateChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final PrivateChatController controller = Get.find<PrivateChatController>();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     // When this chat screen is opened by receiver, mark unseen messages as seen
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.markMessagesAsSeen(widget.chatId, widget.receiverId);
//     });
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.receiverName)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: controller.getMessagesStream(widget.chatId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//                 final messages = snapshot.data!.docs;

//                 WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//                 // Mark unseen messages as seen whenever new data arrives (optional)
//                 controller.markMessagesAsSeen(widget.chatId, widget.receiverId);

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(8),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final data = messages[index].data()! as Map<String, dynamic>;
//                     final currentUserId = controller.currentUser?.uid ?? '';
//                     final isMe = data['senderId'] == currentUserId;
//                     final messageText = data['message'] ?? '';
//                     final isSeen = data['isSeen'] ?? false;

//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Column(
//                         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: isMe ? Colors.blue[200] : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(messageText),
//                           ),
//                           // Show status only for the last message sent by me
//                           if (isMe && index == messages.length - 1)
//                             Text(
//                               isSeen ? "Seen" : "Sent",
//                               style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () async {
//                     final text = _messageController.text.trim();
//                     if (text.isNotEmpty) {
//                       await controller.sendMessage(widget.chatId, text);
//                       _messageController.clear();
//                       _scrollToBottom();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../controllers/private_chat_controller.dart';

// class PrivateChatScreen extends StatefulWidget {
//   final String chatId;
//   final String receiverId;
//   final String receiverName;

//   const PrivateChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.receiverId,
//     required this.receiverName,
//   }) : super(key: key);

//   @override
//   State<PrivateChatScreen> createState() => _PrivateChatScreenState();
// }

// class _PrivateChatScreenState extends State<PrivateChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final PrivateChatController controller = Get.find<PrivateChatController>();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Mark unseen messages as seen when chat is opened
//       controller.markMessagesAsSeen(widget.chatId, widget.receiverId);
//     });
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = controller.currentUser?.uid ?? '';

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.receiverName)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: controller.getMessagesStream(widget.chatId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//                 final messages = snapshot.data!.docs;

//                 WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//                 // Optionally update seen status when new messages arrive
//                 controller.markMessagesAsSeen(widget.chatId, widget.receiverId);

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(8),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final data = messages[index].data()! as Map<String, dynamic>;
//                     final isMe = data['senderId'] == currentUserId;
//                     final messageText = data['message'] ?? '';
//                     final isSeen = data['isSeen'] ?? false;

//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Column(
//                         crossAxisAlignment:
//                             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
//                             decoration: BoxDecoration(
//                               color: isMe ? Colors.blue[300] : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               messageText,
//                               style: TextStyle(
//                                 color: isMe ? Colors.white : Colors.black87,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           if (isMe && index == messages.length - 1)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 2, right: 4),
//                               child: Text(
//                                 isSeen ? "Seen" : "Sent",
//                                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(),
//                     ),
//                     textInputAction: TextInputAction.send,
//                     onSubmitted: (value) async {
//                       final text = value.trim();
//                       if (text.isNotEmpty) {
//                         await controller.sendMessage(widget.chatId, text);
//                         _messageController.clear();
//                         _scrollToBottom();
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () async {
//                     final text = _messageController.text.trim();
//                     if (text.isNotEmpty) {
//                       await controller.sendMessage(widget.chatId, text);
//                       _messageController.clear();
//                       _scrollToBottom();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }


// lib/views/private_chat/private_chat_screen.dart

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../controllers/private_chat_controller.dart';

// class PrivateChatScreen extends StatefulWidget {
//   final String chatId;
//   final String receiverId;
//   final String receiverName;

//   const PrivateChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.receiverId,
//     required this.receiverName,
//   }) : super(key: key);

//   @override
//   State<PrivateChatScreen> createState() => _PrivateChatScreenState();
// }

// class _PrivateChatScreenState extends State<PrivateChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final PrivateChatController controller = Get.find<PrivateChatController>();
//   final ScrollController _scrollController = ScrollController();

//   StreamSubscription? _typingSubscription;
//   bool _otherUserTyping = false;
//   Timer? _typingTimer;

//   @override
//   void initState() {
//     super.initState();

//     // Mark messages as seen when opening chat
//     controller.markMessagesAsSeen(widget.chatId, widget.receiverId);

//     // Listen to typing status changes
//     _typingSubscription = controller.typingStatusStream(widget.chatId).listen((typingMap) {
//       if (!mounted) return;

//       final typing = typingMap[widget.receiverId] ?? false;
//       setState(() {
//         _otherUserTyping = typing;
//       });
//     });

//     // Listen for text input changes to update typing status
//     _messageController.addListener(_onTyping);
//   }

//   void _onTyping() {
//     controller.updateTypingStatus(widget.chatId, true);

//     // Debounce typing status reset after 2 seconds of inactivity
//     _typingTimer?.cancel();
//     _typingTimer = Timer(const Duration(seconds: 2), () {
//       controller.updateTypingStatus(widget.chatId, false);
//     });
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     }
//   }

//   @override
//   void dispose() {
//     _typingSubscription?.cancel();
//     _typingTimer?.cancel();
//     // Make sure to reset typing status when leaving screen
//     controller.updateTypingStatus(widget.chatId, false);
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = controller.currentUser?.uid ?? '';

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.receiverName)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: controller.getMessagesStream(widget.chatId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//                 final messages = snapshot.data!.docs;

//                 WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//                 // Mark unseen messages as seen when new messages arrive
//                 controller.markMessagesAsSeen(widget.chatId, widget.receiverId);

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(8),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final data = messages[index].data()! as Map<String, dynamic>;
//                     final isMe = data['senderId'] == currentUserId;
//                     final messageText = data['message'] ?? '';
//                     final isSeen = data['isSeen'] ?? false;

//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Column(
//                         crossAxisAlignment:
//                             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(10),
//                             constraints: BoxConstraints(
//                                 maxWidth: MediaQuery.of(context).size.width * 0.7),
//                             decoration: BoxDecoration(
//                               color: isMe ? Colors.blue[300] : Colors.grey[300],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               messageText,
//                               style: TextStyle(
//                                 color: isMe ? Colors.white : Colors.black87,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           if (isMe && index == messages.length - 1)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 2, right: 4),
//                               child: Text(
//                                 isSeen ? "Seen" : "Sent",
//                                 style:
//                                     TextStyle(fontSize: 12, color: Colors.grey[600]),
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // Typing indicator below messages
//           if (_otherUserTyping)
//             Padding(
//               padding: const EdgeInsets.only(left: 12, bottom: 6),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "${widget.receiverName} is typing...",
//                   style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//             ),

//           const Divider(height: 1),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(),
//                     ),
//                     textInputAction: TextInputAction.send,
//                     onSubmitted: (value) async {
//                       final text = value.trim();
//                       if (text.isNotEmpty) {
//                         await controller.sendMessage(widget.chatId, text);
//                         _messageController.clear();
//                         _scrollToBottom();
//                         // Update typing status to false after sending
//                         controller.updateTypingStatus(widget.chatId, false);
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () async {
//                     final text = _messageController.text.trim();
//                     if (text.isNotEmpty) {
//                       await controller.sendMessage(widget.chatId, text);
//                       _messageController.clear();
//                       _scrollToBottom();
//                       // Update typing status to false after sending
//                       controller.updateTypingStatus(widget.chatId, false);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/views/private_chat/private_chat_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../controllers/private_chat_controller.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverId;
  final String receiverName;

  const PrivateChatScreen({
    Key? key,
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final PrivateChatController controller = Get.find<PrivateChatController>();
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? _typingSubscription;
  bool _otherUserTyping = false;
  Timer? _typingTimer;
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();

    controller.markMessagesAsSeen(widget.chatId, widget.receiverId);

    _typingSubscription = controller.typingStatusStream(widget.chatId).listen((typingMap) {
      if (!mounted) return;
      final typing = typingMap[widget.receiverId] ?? false;
      setState(() => _otherUserTyping = typing);
    });

    _messageController.addListener(_onTyping);
  }

  void _onTyping() {
    controller.updateTypingStatus(widget.chatId, true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      controller.updateTypingStatus(widget.chatId, false);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _toggleEmojiPicker() {
    FocusScope.of(context).unfocus();
    setState(() => _showEmojiPicker = !_showEmojiPicker);
  }

  void _onEmojiSelected(Emoji emoji) {
    _messageController.text += emoji.emoji;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  @override
  void dispose() {
    _typingSubscription?.cancel();
    _typingTimer?.cancel();
    controller.updateTypingStatus(widget.chatId, false);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = controller.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.getMessagesStream(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                controller.markMessagesAsSeen(widget.chatId, widget.receiverId);

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data()! as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUserId;
                    final messageText = data['message'] ?? '';
                    final isSeen = data['isSeen'] ?? false;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment:
                            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[300] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              messageText,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isMe && index == messages.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 4),
                              child: Text(
                                isSeen ? "Seen" : "Sent",
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          if (_otherUserTyping)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.receiverName} is typing...",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: _toggleEmojiPicker,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) async {
                      final text = value.trim();
                      if (text.isNotEmpty) {
                        await controller.sendMessage(widget.chatId, text);
                        _messageController.clear();
                        _scrollToBottom();
                        controller.updateTypingStatus(widget.chatId, false);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      await controller.sendMessage(widget.chatId, text);
                      _messageController.clear();
                      _scrollToBottom();
                      controller.updateTypingStatus(widget.chatId, false);
                    }
                  },
                ),
              ],
            ),
          ),

          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) => _onEmojiSelected(emoji),
                config: const Config(
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax: 32,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
