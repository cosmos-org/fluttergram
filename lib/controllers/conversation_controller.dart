import '../models/conversation_model.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../util/util.dart';
import 'package:fluttergram/constants.dart';
import 'dart:convert';
final String getChatsURL = hostname + '/api/v1/chats/getChats';
// final String searchPostsURL = hostname + '/api/v1/posts/search';
Conversation conversationFromRespJson(json){
  final String name, messagePreview, avatar, lastMessageTime;
  final bool isActive, isSeen;
  final List<String> messages;
  name = json['partnerName'];
  avatar = json['partnerAvatar'];
  messagePreview = json['latestMessage'];
  lastMessageTime = timeAgo(json['updatedAt']);
  isActive = true;
  isSeen = false;
  messages = [];
  return new Conversation(name: name,messagePreview: messagePreview,avatar: avatar,lastMessageTime: lastMessageTime,messages: messages,isActive: isActive,isSeen: isSeen);
}

Future<List<Conversation>> getConversations() async {
  String token = await getToken();
  final response = await http
      .get(Uri.parse(getChatsURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);
  print(resp);

  if (checkMessageResponse(resp['message'])) {

    var ls = <Conversation>[];
    // for element
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
      ls.add(conversationFromRespJson(element));
    };
    // );

    return ls;
  }

  else return [];
  return [
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
}

Future<Conversation> getConversation({required User user}) async {
  return Conversation(
      name: user.username, messages: ["Hi there", "Hi", "How are you doing?"]);
}
