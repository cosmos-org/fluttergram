import 'dart:convert';
import 'package:fluttergram/util/util.dart';
import 'package:http/http.dart' as http;
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
  String token = await getToken();
  String url = hostname + friendGetListEndpoint;
  print('Get Friends');
  print(token);
  //
  // final response = await http
  //     .post(Uri.parse(url),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'authorization': 'bearer ' + token,
  //   },
  // );
  // var resp = jsonDecode(response.body);
  // print(resp);
  //
  // var ls = <User>[];
  // for (var element in resp['data']['friends']) {
  //   ls.add(User.fromJson(element));
  // }
  return [];
}

Future<User> getCurrentUser() async{
  String token = await getToken();
  String url = hostname + userGetInforEndpoint;
  final response = await http
      .get(Uri.parse(url),
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
  print(headers);
  print(loginUrl);
  print(body);
  Response resp = await post(Uri.parse(loginUrl), headers: headers, body: body);

  int statusCode = resp.statusCode;
  dynamic respBody = jsonDecode(resp.body);
  if (statusCode < 300) {
    User currentUser = User.fromJson(respBody['data']);
    String token = respBody['token'];
    print(currentUser);
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
