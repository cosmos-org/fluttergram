import 'package:flutter/cupertino.dart';

class Conversation {
  final String name, messagePreview, avatar, lastMessageTime;
  final bool isActive, isSeen;
  final List<String> messages;

  Conversation({
    this.name = '',
    this.messages = const [],
    this.messagePreview = '',
    this.lastMessageTime = '',
    this.avatar = '',
    this.isActive = false,
    this.isSeen = false,
  });
}
