import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
import '../../util/util.dart';
import 'package:fluttergram/constants.dart';
import 'dart:convert';
final String getChatsURL = hostname + '/api/v1/chats/getChats';
final String getMessagesURL = hostname + '/api/v1/chats/getMessages';
final String sendMessageURL = hostname + '/api/v1/chats/send';
// final String searchPostsURL = hostname + '/api/v1/posts/search';


Message messageFromRespJson(json){
  final String chatId,id;
  final String content,createdAt,updatedAt;
  final User? user;
  id = json["_id"] ?? '';
  chatId = json['chat'] ?? '';
  content = json['content'] ?? '';

  createdAt = json['createdAt'] ?? '';

  updatedAt = json['updatedAt'] ?? '';
  user= User.fromJson(jsonConvert(json['user']));
  return new Message(id: id, chatId: chatId,content: content,createdAt: createdAt,updatedAt: updatedAt,user: user);
}

Future<List<Conversation>> getConversationsAPI() async {
  Map<String, dynamic> handleJson(json,messages){
    json['lastMessageTimeAgo'] =  timeAgo(json['lastMessageTime']);
    json['messages'] = messages ?? [];
    json['isActive'] = true;
    json['isSeen'] = true;
    return json;
  }
  String token = await getToken();
  final response = await http
      .get(Uri.parse(getChatsURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);

  if (checkMessageResponse(resp['message'])) {

    var ls = <Conversation>[];
    // for element
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
          print('call from conversation');
          var messages = await getMessagesAPI(element['_id'],0);
          ls.add(Conversation.fromJson(handleJson(element,messages)));
        };
    // );
    return ls;
  }

  else return [];

}

Future<List<Message>> getMessagesAPI(chatId,page) async {
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
    ls = List.from(ls.reversed);
    print('load msg ' + page.toString());
    print(ls.length);
    return ls;
  }
  else return [];
}

Future<Message> sendMessageAPI(String content,String chatId,String  receiveId) async{
  String token = await getToken();
  final response = await http
      .post(Uri.parse(sendMessageURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
    body : jsonEncode(<String, String>{
      "chatId" : chatId,
      "receivedId": receiveId,
      "type" : "PRIVATE_CHAT",
      "content": content
    })
  );
  int statusCode = response.statusCode;
  var resp = jsonDecode(response.body);
  if (statusCode < 300) {
    if (checkMessageResponse(resp['message'])) {
      var msgID = resp['data']['_id'] ?? '';
      var msgJson =  resp['data'];
      if (msgID != '') {
       return Message(id: msgJson['_id'],chatId: msgJson['chat']['_id'],
            content:  msgJson['content'],createdAt: msgJson['createdAt'],updatedAt: msgJson['updatedAt'],
            user: User.fromJson(jsonConvert(msgJson['user'])));
      }
    }
    else Message(id: '');
  }
  return Message(id: '');
}

