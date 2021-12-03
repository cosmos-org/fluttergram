import 'dart:convert';
import 'package:fluttergram/util/util.dart';

import '../models/user_model.dart';
import '../models/image_model.dart';
import 'package:fluttergram/constants.dart';
import 'package:http/http.dart';

Future<List<User>> getUsers() async {
  return [
    // User(id: '1', username: "Jenny Wilson", password: ''),
    // User(id: '2', username: "Esther Howard", phonenumber: ''),
    // User(id: '3', username: "Ralph Edwards"),
    // User(id: '4', username: "Jacob Jones"),
    // User(id: '5', username: "Albert Flores"),
  ];
}

Future<List<User>> getFriends() async {
  return [
    User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
        avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
    User(id: '2', username: "Esther Howard",  phone: '0', password: 'a',
        avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
    User(id: '3', username: "Ralph Edwards",  phone: '0', password: 'a',
        avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
    User(id: '4', username: "Jacob Jones", phone: '0', password: 'a',
        avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
    User(id: '5', username: "Albert Flores", phone: '0', password: 'a',
        avatar:Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg"))
  ];
}

Future<User> logIn(String phone, String password) async {
  // TODO Checking input condition

  String body = '{"phonenumber": "$phone", "password": "$password"}';
  Map<String, String> headers = {"Content-type": "application/json"};
  String loginUrl = hostname + userLogInEndpoint;
  print(headers);
  print(loginUrl);
  print(body);
  Response resp = await post(Uri.parse(loginUrl), headers: headers, body: body);

  int statusCode = resp.statusCode;
  dynamic respBody = jsonDecode(resp.body);
  if (statusCode < 300) {
    User currentUser = User.fromJson(respBody);
    print(currentUser);
    return currentUser;
  } else {
    String message = respBody["message"];
    return User(id: '-1', username: "Error", phone: statusCode.toString(), password: message);
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

Future<User> show() async {
  String token = await getToken();
  print('token ne: '+token);
  String showUrl = hostname + userGetInforEndpoint;
  Response resp = await get(Uri.parse(showUrl) ,headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'authorization': 'bearer ' + token,
  });
  int statusCode = resp.statusCode;
  dynamic respBody = jsonDecode(resp.body);
  if (statusCode < 300) {
    User currentUser = User.fromJson(respBody);
    print(currentUser);
    return currentUser;
  } else {
    String message = respBody["message"];
    return User(id: '-1', username: "Error", phone: statusCode.toString(), password: message);
  }
}