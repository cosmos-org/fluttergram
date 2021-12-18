import 'dart:convert';
import 'package:fluttergram/controllers/home/post_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/util/util.dart';
import '../models/user_model.dart';
import 'package:fluttergram/constants.dart';
import 'package:http/http.dart';

Future<List<User>> getFriends() async {
  String token = await getToken();
  String url = hostname + friendGetListEndpoint;
  final response = await post(Uri.parse(url),
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

Future<User> getCurrentUser() async{
  String token = await getToken();
  String url = hostname + userGetInforEndpoint;
  final response = await get(Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'bearer ' + token,
    },
  );
  var resp = jsonDecode(response.body);
  User currentUser = User.fromJson(resp['data']);
  return currentUser;
}

Future<List> logIn(String phone, String password) async {
  // TODO Checking input condition

  String body = '{"phonenumber": "$phone", "password": "$password"}';
  Map<String, String> headers = {"Content-type": "application/json",};
  String loginUrl = hostname + userLogInEndpoint;
  Response resp = await post(Uri.parse(loginUrl), headers: headers, body: body);

  int statusCode = resp.statusCode;
  dynamic respBody = jsonDecode(resp.body);
  if (statusCode < 300) {
    User currentUser = User.fromJson(respBody['data']);
    String token = respBody['token'];
    return [currentUser,token];
  } else {
    String message = respBody["message"];
    return [User(id: '-1', username: "Error", phone: statusCode.toString(), password: message),''];
  }
}

Future signUp(String username, String phone, String password) async {
  String body = '{"username": "$username", '
      '"phonenumber": "$phone",'
      '"password": "$password"}';
  Map<String, String> headers = {"Content-type": "application/json"};
  String signupUrl = hostname + userSignUpEndpoint;
  Response resp = await post(Uri.parse(signupUrl), headers: headers, body: body);
  return resp.statusCode;
}

Future<User> getUser() async {
  String token = await getToken();
  String showUrl = hostname + userGetInforEndpoint;
  Response resp = await get(Uri.parse(showUrl) ,headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'authorization': 'bearer ' + token,
  });
  int statusCode = resp.statusCode;
  dynamic respBody = jsonDecode(resp.body);
  if (statusCode < 300) {
    User currentUser = User.fromJson(respBody['data']);
    return currentUser;
  } else {
    String message = respBody["message"];
    return User(id: '-1', username: "Error", phone: statusCode.toString(), password: message);
  }
}


Future<User> getAnotherUser(String UserId) async {
  String token = await getToken();
  String showUrl = hostname + userGetAnotherEndpoint + UserId;
  Response resp = await get(Uri.parse(showUrl) ,headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'authorization': 'bearer ' + token,
  });
  int statusCode = resp.statusCode;
  dynamic respBody = jsonDecode(resp.body);
  if (statusCode < 300) {
    User anotherUser = User.fromJson(respBody['data']);
    return anotherUser;
  } else {
    String message = respBody["message"];
    return User(id: '-1', username: "Error", phone: statusCode.toString(), password: message);
  }
}

Future<Profile> show() async{
  User user = await getUser();
  if(user.gender=="secret"){
    user.gender = "Secret";
  }
  if(user.gender=="male"){
    user.gender = "Male";
  }
  if(user.gender=="female"){
    user.gender = "Female";
  }
  List<User> lf = await getFriends();
  List<Post> lp = await getPosts();
  int numFriends = lf.length, numPosts = lp.length;
  Profile p = Profile(user, numPosts, numFriends, lp);
  return p;
}

Future<Profile> showAnotherProfile(String userId) async{
  User user = await getAnotherUser(userId);
  if(user.gender=="secret"){
    user.gender = "Secret";
  }
  if(user.gender=="male"){
    user.gender = "Male";
  }
  if(user.gender=="female"){
    user.gender = "Female";
  }
  List<Post> lp = await getPostsByUserId(userId);
  int numFriends = 0, numPosts = lp.length;
  Profile p = Profile(user, numPosts, numFriends, lp);
  return p;
}

Future edit(String username, String description, String gender, String imageEncode) async{
  String token = await getToken();
  String url = hostname + userEditInforEndpoint;
  String param;
  if (gender=='Male'){
    gender = 'male';
  }
  if (gender=='Female'){
    gender = 'female';
  }
  if (gender=='Secret'){
    gender = 'secret';
  }
  if (imageEncode==''){
    param = '{"username": "$username", "description": "$description", "gender": "$gender"}';
  }
  else {
    param = '{"username": "$username", "description": "$description", "gender": "$gender", "avatar": "data:image/jpeg;base64,$imageEncode"}';
  }
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'authorization': 'bearer ' + token,
  };
  Response resp = await post(Uri.parse(url), headers: headers, body: param);
  return resp.statusCode;
}

Future changePassword(String oldPass, String newPass) async{
  String token = await getToken();
  String url = hostname + userChangePasswordEndpoint;
  String param = '{"currentPassword": "$oldPass", "newPassword": "$newPass"}';
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'authorization': 'bearer ' + token,
  };
  Response resp = await post(Uri.parse(url), headers: headers, body: param);
  return resp.statusCode;
}

Future<List<User>> getListFriendsRequest() async{
  String token = await getToken();
  String url = hostname + friendGetListsRequestsEndPoint;
  final response = await post(Uri.parse(url),
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

Future<List<User>> getListUsersSentRequest() async{
  String token = await getToken();
  String url = hostname + friendGetListsSentRequestEndPoint;
  final response = await post(Uri.parse(url),
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

Future<String> getStatusUser(String userId) async{
  String status = 'noFriend';
  List<User> listFriends = await getFriends();
  for (var element in listFriends){
    if (userId == element.id){
      status = 'friend';
      break;
    }
  }
  if (status == 'noFriend'){
    List<User> listUsersSentRequest = await getListUsersSentRequest();
    for (var element in listUsersSentRequest){
      if (userId == element.id){
        status = 'userSentRequest';
        break;
      }
    }
  }
  if (status == 'noFriend'){
    List<User> listFriendsRequest = await getListFriendsRequest();
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

Future<bool> removeFriend(String userId) async {
  String token = await getToken();
  String url = hostname + friendSetRemove;
  String param = '{"user_id": "$userId"}';
  final response = await post(Uri.parse(url),
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

Future<bool> requestFriend(String userId) async {
  String token = await getToken();
  String url = hostname + friendSetRequest;
  String param = '{"user_id": "$userId"}';
  final response = await post(Uri.parse(url),
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

Future<bool> acceptFriend(String userId, String mode) async {
  String token = await getToken();
  String url = hostname + friendSetAccept;
  String param = '{"user_id": "$userId", "is_accept": "$mode"}';
  final response = await post(Uri.parse(url),
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

Future<bool> removeRequestFriend(String userId) async {
  String token = await getToken();
  String url = hostname + friendSetRemoveRequest;
  String param = '{"user_id": "$userId"}';
  final response = await post(Uri.parse(url),
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

