class Conversation {
  final String name, messagePreview, avatar, lastMessageTime;
  final bool isActive, isSeen;

  Conversation({
    this.name = '',
    this.messagePreview = '',
    this.lastMessageTime = '',
    this.avatar = '',
    this.isActive = false,
    this.isSeen = false,
  });
}

final List CONVERSATIONS = [
  Conversation(
    name: "Jenny Wilson",
    messagePreview: "Hope you are doing well after that ",
    avatar: "assets/images/user.png",
    lastMessageTime: "3m",
    isActive: false,
    isSeen: false,
  ),
  Conversation(
    name: "Esther Howard",
    messagePreview: "Hello Abdullah! I'm from CS50 class",
    avatar: "assets/images/user_2.png",
    lastMessageTime: "8m",
    isActive: true,
    isSeen: true,
  ),
  Conversation(
    name: "Ralph Edwards",
    messagePreview: "Do you have update about the final project?",
    avatar: "assets/images/user_3.png",
    lastMessageTime: "5d",
    isActive: false,
    isSeen: true,
  ),
  Conversation(
    name: "Jacob Jones",
    messagePreview: "You’re welcome :)",
    avatar: "assets/images/user_4.png",
    lastMessageTime: "5d",
    isActive: true,
    isSeen: true,
  ),
  Conversation(
    name: "Albert Flores",
    messagePreview: "Thanks",
    avatar: "assets/images/user_5.png",
    lastMessageTime: "6d",
    isActive: false,
    isSeen: false,
  ),
  Conversation(
    name: "Jenny Wilson",
    messagePreview: "Hope you are doing well after that ",
    avatar: "assets/images/user.png",
    lastMessageTime: "3m",
    isActive: false,
    isSeen: false,
  ),
  Conversation(
    name: "Esther Howard",
    messagePreview: "Hello Abdullah! I'm from CS50 class",
    avatar: "assets/images/user_2.png",
    lastMessageTime: "8m",
    isActive: true,
    isSeen: true,
  ),
  Conversation(
    name: "Ralph Edwards",
    messagePreview: "Do you have update about the final project?",
    avatar: "assets/images/user_3.png",
    lastMessageTime: "5d",
    isActive: false,
    isSeen: true,
  ),
];
