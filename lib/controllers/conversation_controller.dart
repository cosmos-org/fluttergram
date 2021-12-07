import '../models/conversation_model.dart';
import '../models/message_model.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../util/util.dart';
import 'package:fluttergram/constants.dart';
import 'dart:convert';
final String getChatsURL = hostname + '/api/v1/chats/getChats';
final String getMessagesURL = hostname + '/api/v1/chats/getMessages';
// final String searchPostsURL = hostname + '/api/v1/posts/search';
Conversation conversationFromRespJson(json,messages){
  final String id,name, messagePreview, avatar, lastMessageTime;
  final bool isActive, isSeen;
  id = json["_id"] ?? '';
  name = json['partnerName'] ?? '';
  avatar = json['partnerAvatar'] ?? '';
  messagePreview = json['latestMessage'] ?? '';
  lastMessageTime = timeAgo(json['updatedAt']);
  isActive = true;
  isSeen = false;

  return new Conversation(id: id,name: name,messagePreview: messagePreview,avatar: avatar,lastMessageTime: lastMessageTime,messages: messages,isActive: isActive,isSeen: isSeen);
}

Message messageFromRespJson(json){
  final String chatId,id;
  final String? content,createdAt,updatedAt;
  final User? user;
  id = json["_id"] ?? '';
  chatId = json['chat'] ?? '';
  content = json['content'] ?? '';
  createdAt = json['createdAt'] ?? '';
  updatedAt = json['updatedAt'] ?? '';
  user= User.fromJson(jsonConvert(json['user']));
  return new Message(id: id, chatId: chatId,content: content,createdAt: createdAt,updatedAt: updatedAt,user: user);
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
          var messages = await getMessages(element['_id'],0);
      ls.add(conversationFromRespJson(element,messages));
    };
    // );

    return ls;
  }

  else return [];

}
Future<List<Message>> getMessages(chatId,page) async {
  String token = await getToken();
  final response = await http
      .get(Uri.parse(getMessagesURL + '/${chatId}?page=${page}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);
  if (checkMessageResponse(resp['message'])) {
    var ls = <Message>[];
    // for element
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
      ls.add(messageFromRespJson(element));
    };
    // );
    return ls;
  }
  else return [];
}
Future<Conversation> getConversation({required User user}) async {
  return Conversation(
      id: '1',name: user.username, messages: []);
}
