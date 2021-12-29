import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:fluttergram/default_screen.dart';
late DefaultScreenState globalDefaultScreenRef;
void saveDefaultScreenRef(DefaultScreenState t){
  globalDefaultScreenRef = t;
}
const String getFileUrl = hostname+ '/files/';
String dateTimeFormat(String dateMongo){
  final t = DateTime.parse(dateMongo);
  Duration diff = DateTime.now().difference(t);
  var a = DateTime.now().subtract(diff);
  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
  var outputDate = outputFormat.format(a);
  return outputDate;
}
String getStaticURL(String fileName){
  return getFileUrl + fileName;
}

//Calculate time-ago format of a mongo-date-string
String timeAgo(String dateMongo) {
  if (dateMongo == '') return '';
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

String stringConver(jsonValue){

  if (jsonValue == null) {
    return '';
  }
  if (jsonValue.runtimeType == String) {
    return jsonValue;
  }
  try {
    jsonValue = Map<String,dynamic>.from(jsonValue);
    return jsonValue['_id'] ?? '';
  }
  catch (e){
    return '';
  };

}
//for example:  Image: getImageProviderNetWork(fileName),
Image getImageNetWork(fileName) {

    return Image.network(
            getFileUrl + fileName,
         fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
             return  Image.asset(
               'assets/default_image.jpg',
               fit: BoxFit.cover,
             );
          },
            );

}
const defaul_link = 'https://i.pinimg.com/564x/c2/5a/08/c25a08a1ec74b627d30139b17304db75.jpg';
//for example:  backgroundImage: getImageProviderNetWork(fileName),
NetworkImage getImageProviderNetWork(fileName) {

  try {
    return NetworkImage(
      getFileUrl + fileName,
    );
  } catch (e){
    return NetworkImage(
        defaul_link
    );
  }
}

Future<void> setCurrentUserId(String currentUserId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
  if (token != Null) {
    token = token.toString();
    await prefs.setString('token', token);
  };
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token').toString();
}

List passwordValidation(String password) {
  if(password == "") return [false, "Invalid password"];
  RegExp passwordRegex = new RegExp("");
  if (!passwordRegex.hasMatch(password)) return [false, "Invalid password"];
  return [true, "valid"];
}

List confirmPasswordValidation(String confirmPassword, String password) {
  if(confirmPassword != password) return [false, "Confirm password does not match"];
  return [true, "valid"];
}

List phoneValidation(String phone) {
  if(phone == "") return [false, "valid"];
  // RegExp phoneRegex = new RegExp(r"(84|0[3|5|7|8|9])+([0-9]{8})\b");
  // if (!phoneRegex.hasMatch(phone)) return [false, "Invalid phone number!"];
  return [true, "valid"];
}

List inputValidation(String screen, String username, String phone,
    String password, String retypePassword) {
  RegExp phoneRegex = new RegExp(r"^\d{5}$");
  RegExp passwordRegex = new RegExp("");
  if (!phoneRegex.hasMatch(phone)) return [false, "Invalid phone number!"];
  switch (screen) {
    case "login":
      if (!passwordRegex.hasMatch(password)) return [false, "Invalid password!"];
      break;
    case "signup":
      if (!passwordRegex.hasMatch(password) || !passwordRegex.hasMatch(retypePassword)) return [false, "Invalid password"];
      if (password != retypePassword) return [false, "Unmatched confirm password"];
      break;
  }
  return [true, "Valid"];
}

Future<String> encodeFile(File file) async {
  var bytes = (await file.readAsBytes());
  String base64Encode = base64.encode(bytes);
  return base64Encode;
}

Future<String> encodeImage(String fileName) async {
  File file = await ImageUrlToFile(fileName);
  return encodeFile(file);
}

Future<File> ImageUrlToFile(String fileName) async {
  String imageUrl = getFileUrl + fileName;
  final http.Response responseData = await http.get(Uri.parse(imageUrl));
  var unit8list = responseData.bodyBytes;
  var buffer = unit8list.buffer;
  ByteData byteData = ByteData.view(buffer);
  var tempDir = await getTemporaryDirectory();
  File file = await File('${tempDir.path}/img').writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
}
