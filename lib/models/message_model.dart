import 'package:flutter/cupertino.dart';
import 'package:fluttergram/models/user_model.dart';

class Message {
  String chatId,id;
  String content,createdAt,updatedAt;
  User? user;
  User? receiveUser;

  Message({
    required this.id,
    this.chatId = '',
    this.content = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.user,
    this.receiveUser
  });
  bool checkMsgUserId(anotherId){
    return this.user!.id == anotherId;
  }

  @override
  String toString() {
    return 'Message{chatId: $chatId, id: $id, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, receiveUser: $receiveUser}';
  }
}
