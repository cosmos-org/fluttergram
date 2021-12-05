import 'package:flutter/material.dart';
import '../../constants.dart';
import '../socket/custom_socket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String getFileUrl = hostname+ '/files/';


//Calculate time-ago format of a mongo-date-string
String timeAgo(String dateMongo) {
  final t = DateTime.parse(dateMongo);
  Duration diff = DateTime.now().difference(t);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ";
  return "Just now";
}

bool checkMessageResponse(message){
  if
  (message.toLowerCase().contains('success')) return true;
  else return false;
}
//try catch
Map<String, dynamic> jsonConvert(jsonValue){

  if (jsonValue == null) {
    return {'null': 'null'};
  }
  if (jsonValue.runtimeType == String) {
    return {"_id": jsonValue};
  }
  try {
    jsonValue = Map<String,dynamic>.from(jsonValue);
    return jsonValue;
  }
  catch (e){
    return {'null': 'null'};
  };

}
//for example:  Image: getImageProviderNetWork(fileName),
Image getImageNetWork(fileName) {
  return Image.network(
    getFileUrl + fileName,
    fit: BoxFit.cover,
  );
}
//for example:  backgroundImage: getImageProviderNetWork(fileName),
NetworkImage getImageProviderNetWork(fileName) {
  return NetworkImage(
    getFileUrl + fileName,
  );
}

Future<void> setCurrentUserId(String currentUserId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('currentUserId:  $currentUserId.');
  if (currentUserId != Null) {
    await prefs.setString('currentUserId', currentUserId);
  };
}
Future<String> getCurrentUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('currentUserId').toString();
}


Future<void> setToken(String? token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('Token:  $token.');
  if (token != Null) {
    token = token.toString();
    await prefs.setString('token', token);
  };
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token').toString();
}