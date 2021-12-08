import 'package:flutter/cupertino.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../util/util.dart';
class Conversation {
  String id, messagePreview, lastMessageTime;
  bool isActive, isSeen;
  List<Message> messages;
  User? partnerUser;
  Conversation({
    required this.id,
    this.messages = const [],
    this.messagePreview = '',
    this.lastMessageTime = '',
    this.partnerUser,
    this.isActive = false,
    this.isSeen = false,
  });
  void updateWithNewMsg(Message msg){
    this.lastMessageTime = timeAgo(msg.updatedAt);
    this.messagePreview = msg.content;
    this.messages.add(msg);
  }
  factory Conversation.fromJson(Map<String, dynamic> json){
    var a= Conversation(
      id: json['_id'] ?? '',
      messagePreview: json['messagePreview'] ?? '',
      lastMessageTime: timeAgo(json['lastMessageTime']) ??  '',
      isActive: json['isActive'] ?? true,
      isSeen: json['isSeen'] ?? false,
      messages : json['messages'] ?? [],
      partnerUser: User.fromJson(jsonConvert(json['partnerUser'])),
    );
    return a;
  }

  @override
  String toString() {
    return 'Conversation{id: $id, messagePreview: $messagePreview, lastMessageTime: $lastMessageTime, isActive: $isActive, isSeen: $isSeen, messages: $messages, partnerUser: $partnerUser}';
  }
}
