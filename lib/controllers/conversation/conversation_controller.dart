import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
import '../../util/util.dart';
import 'package:fluttergram/constants.dart';
import 'dart:convert';
final String getChatsURL = hostname + '/api/v1/chats/getChats';
final String getChatByUserIdURL = hostname + '/api/v1/chats/getChatByUserId/';
final String getMessagesURL = hostname + '/api/v1/chats/getMessages';
final String sendMessageURL = hostname + '/api/v1/chats/send';
final String searchUsersURL = hostname + '/api/v1/users/search';
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
  Map<String, dynamic> handleConversationJson(json,messages){
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
    int i = 0;
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
          // print('call from conversation');

          // var messages = await getMessagesAPI(element['_id'],0);

          var messages = <Message>[];
          // print('load conver');
          // print(z);
          ls.add(Conversation.fromJson(handleConversationJson(element,messages)));
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
    // ls = List.from(ls.reversed);

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

Future<List<Conversation>> searchConversationAPI(String keyword,List<Conversation> conversationList)  async {
  List<String> extractUserFromConversations(List<Conversation> convers){
    var  userLs = <String>[];
    for (var element in convers)
        {
      userLs.add(element.partnerUser!.id!);
    };
    return userLs;
  }
  var chattingUser = extractUserFromConversations(conversationList);
  String currentId = await getCurrentUserId();
  String token = await getToken();
  final response = await http
      .post(Uri.parse(searchUsersURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
    body: jsonEncode(<String, String>{
      'keyword': keyword,
    }),
  );
  var resp = jsonDecode(response.body);

  if (checkMessageResponse(resp['message'])) {

    var finalConversationSearchList = <Conversation>[];
    // for element
    for (var element in resp['data'])
        {
          // print(element['_id']);
          bool found = false; //check whether user have chat with current user
          chattingUser.asMap().forEach((index,value)  {
          if (value == element['_id']){
              found = true;
              finalConversationSearchList.add(conversationList[index]);
          }
          });
            if (!found) {
              if (element['_id'] == currentId) continue;
              Map<String,dynamic> new_element = {};
              new_element['partnerUser'] = element;
              finalConversationSearchList.add(Conversation.fromJson(new_element));
            }
        }
    return finalConversationSearchList;
  }

  else return [];

}

Future<Conversation> getConversationsByPartnerUserIdAPI(String partnerUserId) async {
  Map<String, dynamic> handleConversationJson(json,messages){
    json['lastMessageTimeAgo'] =  timeAgo(json['lastMessageTime']);
    json['messages'] = messages ?? [];
    json['isActive'] = true;
    json['isSeen'] = true;
    return json;
  }
  String token = await getToken();
  final response = await http
      .get(Uri.parse(getChatByUserIdURL + partnerUserId),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);
  late Conversation conversation;
  if (checkMessageResponse(resp['message'])) {
    var messages = <Message>[];
    conversation = Conversation.fromJson(handleConversationJson(resp['data'],messages));

  }
  else conversation =  Conversation.fromJson({});
  print('get conver by partner id');
  print(conversation);
  return conversation;
}
