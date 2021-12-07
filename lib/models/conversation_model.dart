import 'package:flutter/cupertino.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
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

  @override
  String toString() {
    return 'Conversation{id: $id, messagePreview: $messagePreview, lastMessageTime: $lastMessageTime, isActive: $isActive, isSeen: $isSeen, messages: $messages, partnerUser: $partnerUser}';
  }
}
