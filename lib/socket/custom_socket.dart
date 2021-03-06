import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../screens/conversations/conversation_screen.dart';
import '../screens/conversations/chat_screen.dart';
import '../util/util.dart';
import 'dart:async';
import 'dart:convert';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../util/util.dart';
import 'package:fluttergram/constants.dart';
import 'dart:convert';
import 'dart:math';


final String socketMessageEvent = 'message';
final String socketSignInEvent = 'signin';
late CustomSocket  globalCustomSocket;



Future<void> initGlobalCustomSocket  (curentUserId) async {
  globalCustomSocket = CustomSocket(curentUserId);
  globalCustomSocket.connect();
}
class CustomSocket{
  late IO.Socket  socket;
  late String currentUserId;
  late ConversationScreenBodyState conversationScreenBodyState;
  late ChatScreenState chatScreenState;
  CustomSocket(this.currentUserId);
  void initConversationState(ConversationScreenBodyState t){
    this.conversationScreenBodyState = t;
  }
  void initChatScreenState(ChatScreenState  t){
    this.chatScreenState = t;
  }
  void connect(){
    socket = IO.io(socketHostname, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit(socketSignInEvent, this.currentUserId);
    socket.onConnect((data) {
      print('connected socket');
      socket.on(socketMessageEvent, (socketMsg) {
        Message msg = Message.fromJson(socketMsg);
        conversationScreenBodyState.handleNewMessage(msg);
        chatScreenState.handleNewMessage(msg);
      });
    });
  }
  void sendMessage(Message msg,receiveUserId){
    var socketMsg = msg.toMap();
    socket.emit(socketMessageEvent,{'socketMsg' : socketMsg ,'receiveUserId':receiveUserId} );
    conversationScreenBodyState.handleNewMessageFromCurrent(msg, receiveUserId);
  }



  @override
  String toString() {
    return 'CustomSocket{socket: $socket, currentUserId: $currentUserId, conversationScreenBodyState: $conversationScreenBodyState, chatScreenState: $chatScreenState}';
  }
}
