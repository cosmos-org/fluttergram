import 'package:flutter/cupertino.dart';
import 'package:fluttergram/models/user_model.dart';

class Message {
  final String chatId,id;
  final String? content,createdAt,updatedAt;
  final User? user;


  Message({
    required this.id,
    this.chatId = '',
    this.content = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.user,
  });

  @override
  String toString() {
    return 'Message{chatId: $chatId, id: $id, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, user: $user}';
  }
}
