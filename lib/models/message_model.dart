import 'package:flutter/cupertino.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/util/util.dart';

class Message {
  String chatId,id;
  String content,createdAt,updatedAt;
  User? user;
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      '_id': id,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user!.toMap(),
    };
  }
  Message({
    required this.id,
    this.chatId = '',
    this.content = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.user,
  });
  bool checkMsgUserId(anotherId){
    return this.user!.id == anotherId;
  }
  factory Message.fromJson(Map<String, dynamic> json){
    var a= Message(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? 'images',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      user : User.fromJson(jsonConvert(json['user'])),
    );
    return a;
  }
  @override
  String toString() {
    return 'Message{chatId: $chatId, id: $id, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, user: $user}';
  }

}
