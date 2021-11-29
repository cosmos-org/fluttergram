import 'dart:convert';
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
        avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    User(id: '2', username: "Esther Howard",  phone: '0', password: 'a',
        avatar: Image(id:'1', type: 'a', filename: "assets/images/user_2.png")),
    User(id: '3', username: "Ralph Edwards",  phone: '0', password: 'a',
        avatar: Image(id:'1', type: 'a', filename: "assets/images/user_3.png")),
    User(id: '4', username: "Jacob Jones", phone: '0', password: 'a',
        avatar: Image(id:'1', type: 'a', filename: "assets/images/user_4.png")),
    User(id: '5', username: "Albert Flores", phone: '0', password: 'a',
        avatar:Image(id:'1', type: 'a', filename: "assets/images/user_5.png"))
  ];
}

Future<User> logIn(String phone, String password) async {
  // TODO Checking input condition

  String body = '{"phonenumber": "$phone", "password": "$password"}';
  Map<String, String> headers = {"Content-type": "application/json"};
  String loginUrl = hostname + userLogInEndpoint;
  Response resp = await post(Uri.parse(loginUrl), headers: headers, body: body);

  int statusCode = resp.statusCode;
  dynamic respBody = jsonDecode(resp.body);
  if (statusCode < 300) {
    User currentUser = User.fromJson(respBody);
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
