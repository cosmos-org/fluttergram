import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
const String getFileUrl = hostname+ '/files/';
bool checkMessageResponse(message){
  if
  (message.toLowerCase().contains('success')) return true;
  else return false;
}
Map<String, dynamic> jsonConvert(jsonValue){
  print('in conver');
  print(jsonValue);
  print(jsonValue.runtimeType);
  print("is null " + (jsonValue == null).toString());
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

Image getImageNetWork(fileName) {
  return Image.network(
    getFileUrl + fileName,
    fit: BoxFit.cover,
  );
}

NetworkImage getImageProviderNetWork(fileName) {
  return NetworkImage(
    getFileUrl + fileName,
  );
}


void setToken(String? token) async {
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