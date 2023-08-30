import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  ChatBubble({
    super.key,
    required this.text,
    required this.source, // text from sender or receiver
  });
  final String text;
  final String source;
  final DateTime time = DateTime.now();

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final user = FirebaseAuth.instance.currentUser!;
  BoxDecoration senderChatDeco = const BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10)),
    color: Colors.blueGrey,
  );
  BoxDecoration receiverChatDeco = const BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10)),
    color: Colors.grey,
  );

  BoxDecoration setBoxDeco() {
    return widget.source == user.uid ? senderChatDeco : receiverChatDeco;
  }

  TextStyle styleToUse() {
    return widget.source == user.uid
        ? const TextStyle(color: Colors.white)
        : const TextStyle(color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: setBoxDeco(),
      child: Text(
        widget.text,
        style: styleToUse(),
      ),
    );
  }
}
