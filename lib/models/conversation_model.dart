import 'package:flutter/cupertino.dart';
import '../models/message_model.dart';
class Conversation {
  final String id, name, messagePreview, avatar, lastMessageTime;
  final bool isActive, isSeen;
  final List<Message> messages;

  Conversation({
    required this.id,
    this.name = '',
    this.messages = const [],
    this.messagePreview = '',
    this.lastMessageTime = '',
    this.avatar = '',
    this.isActive = false,
    this.isSeen = false,
  });

  @override
  String toString() {
    return 'Conversation{id: $id, name: $name, messagePreview: $messagePreview, avatar: $avatar, lastMessageTime: $lastMessageTime, isActive: $isActive, isSeen: $isSeen, messages: $messages}';
  }
}
