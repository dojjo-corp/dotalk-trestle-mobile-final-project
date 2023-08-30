import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? text;
  String? source;
  Timestamp timeCreated = Timestamp.now();
  ChatModel({this.text, this.source});
}

List<ChatModel> chats = [
  ChatModel(
    text: 'hello!',
    source: 'user',
  ),
  ChatModel(
    text: 'hi!',
    source: 'agent',
  ),
  ChatModel(
    text: 'how can I help?',
    source: 'agent',
  ),
  ChatModel(
    text: 'Just checking up!',
    source: 'user',
  ),
];
