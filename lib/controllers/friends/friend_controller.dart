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
final String searchUsersURL = hostname + '/api/v1/users/search';
// final String searchPostsURL = hostname + '/api/v1/posts/search';

Future<List<User>> getFriendsAPI() async {
  String token = await getToken();
  String url = hostname + friendGetListEndpoint;
  final response = await http.post(Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);
  var ls = <User>[];
  for (var element in resp['data']['friends']) {
    ls.add(User.fromJson(element));
  }
  return ls;
}

Future<List<User>> getListFriendsRequestAPI() async{
  String token = await getToken();
  String url = hostname + friendGetListsRequestsEndPoint;
  final response = await http.post(Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);
  var ls = <User>[];
  for (var element in resp['data']['friends']) {
    ls.add(User.fromJson(element));
  }
  return ls;
}

Future<List<User>> getListUsersSentRequestAPI() async{
  String token = await getToken();
  String url = hostname + friendGetListsSentRequestEndPoint;
  final response = await http.post(Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);
  var ls = <User>[];
  for (var element in resp['data']['friends']) {
    ls.add(User.fromJson(element));
  }
  return ls;
}

Future<bool> removeFriendAPI(String userId) async {
  String token = await getToken();
  String url = hostname + friendSetRemove;
  String param = '{"user_id": "$userId"}';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: param
  );
  if (response.statusCode<300){
    return true;
  }
  else{
    return false;
  }
}

Future<bool> requestFriendAPI(String userId) async {
  String token = await getToken();
  String url = hostname + friendSetRequest;
  String param = '{"user_id": "$userId"}';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: param
  );
  if (response.statusCode<300){
    return true;
  }
  else{
    return false;
  }
}
Future<bool> removeRequestFriendAPI(String userId) async {
  String token = await getToken();
  String url = hostname + friendSetRemoveRequest;
  String param = '{"user_id": "$userId"}';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: param
  );
  if (response.statusCode<300){
    return true;
  }
  else{
    return false;
  }
}
Future<List<dynamic>> acceptFriendAPI(String userId, String mode) async {
  Map<String, dynamic> handleConversationJson(json,messages){
    json['lastMessageTimeAgo'] =  timeAgo(json['lastMessageTime']);
    json['messages'] = messages ?? [];
    json['isActive'] = true;
    json['isSeen'] = true;
    return json;
  }
  String token = await getToken();
  String url = hostname + friendSetAccept;
  String param = '{"user_id": "$userId", "is_accept": "$mode"}';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: param
  );
  if (response.statusCode<300){
    // if accept success, return conversation model
    if (mode == "1"){
      var resp = jsonDecode(response.body);
      var messages = <Message>[];
      Conversation conversation = Conversation.fromJson(handleConversationJson(resp['data']['chat'],messages));
      return [true,conversation];
    } else {
      return [true,null];
    }
  }
  else{
    return [false,null];
  }
}


Future<String> getStatusUser_(String userId) async{
  String status = 'noFriend';
  List<User> listFriends = await getFriendsAPI();
  for (var element in listFriends){
    if (userId == element.id){
      status = 'friend';
      break;
    }
  }
  if (status == 'noFriend'){
    List<User> listUsersSentRequest = await getListUsersSentRequestAPI();
    for (var element in listUsersSentRequest){
      if (userId == element.id){
        status = 'userSentRequest';
        break;
      }
    }
  }
  if (status == 'noFriend'){
    List<User> listFriendsRequest = await getListFriendsRequestAPI();
    for (var element in listFriendsRequest){
      if (userId == element.id){
        status = 'friendRequest';
        break;
      }
    }
  }
  switch (status) {
    case 'friend':
      return 'Remove friend';
    case 'friendRequest':
      return 'Accept friend';
    case 'userSentRequest':
      return 'Cancel request';
    default:
      return 'Add friend';
  }
}
