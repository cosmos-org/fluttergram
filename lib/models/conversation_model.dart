import 'package:flutter/cupertino.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../util/util.dart';
class Conversation {
  String id, latestMessage, lastMessageTimeAgo;
  bool isActive, isSeen;
  List<Message> messages;
  User? partnerUser;
  int sender;
  Conversation({
    required this.id,
    this.messages = const [],
    this.latestMessage = '',
    this.lastMessageTimeAgo = '',
    this.partnerUser,
    this.isActive = false,
    this.isSeen = false,
    this.sender = 0,
  });
  void updateWithNewMsg(Message msg){
    this.lastMessageTimeAgo = timeAgo(msg.updatedAt);
    this.latestMessage = msg.content;
    this.messages.insert(0,msg);
    this.sender = (msg.user!.id == this.partnerUser!.id) ? 1: 0;
  }
  factory Conversation.fromJson(Map<String, dynamic> json){

    var a= Conversation(
      id: json['_id'] ?? '',
      latestMessage: json['latestMessage'] ?? '',
      lastMessageTimeAgo: json['lastMessageTimeAgo'] ??  '',
      isActive: json['isActive'] ?? true,
      isSeen: json['isSeen'] ?? false,
      messages : json['messages'] ?? [],
      partnerUser: User.fromJson(jsonConvert(json['partnerUser'] ?? {})),
        sender: json['sender'] ??  0
    );
    return a;
  }

  @override
  String toString() {
    return 'Conversation{id: $id, messagePreview: $latestMessage, lastMessageTime: $lastMessageTimeAgo, isActive: $isActive, isSeen: $isSeen, messages: $messages, partnerUser: $partnerUser}';
  }
}
