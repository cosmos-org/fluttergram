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
final String socketOnlineEvent = 'online';
final String socketOfflineEvent = 'offline';
final String socketReadMsgEvent = 'read';
final String socketBeReadEvent = 'be_read';
final String socketRequestOnlineEvent = 'request_online';
final String socketResponseOnlineEvent = 'online_list';

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
  bool haveConversationState = false;
  bool haveChatState = false;
  CustomSocket(this.currentUserId);
  void initConversationState(ConversationScreenBodyState t){
    this.conversationScreenBodyState = t;
    this.haveConversationState = true;
    socket.emit(socketRequestOnlineEvent);
  }
  void initChatScreenState(ChatScreenState  t){
    this.chatScreenState = t;
    this.haveChatState = true;
  }
  void cancelChatState(){
    this.haveChatState = false;
  }
  void cancelConversationState(){
    this.haveConversationState = false;

  }
  void readMsg(partnerId){
    // this.conversationScreenBodyState.readMsg(partnerId);
    socket.emit(socketReadMsgEvent, {'current': this.currentUserId, 'target': partnerId});
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
        if (this.haveChatState)  chatScreenState.handleNewMessage(msg);
      });
      socket.on(socketBeReadEvent,(partner){
        if (this.haveChatState)
          this.chatScreenState.beReadMsg(partner);
      });
      socket.on(socketResponseOnlineEvent, (online_ls){
        while (conversationScreenBodyState == null){
        };
        try {
          conversationScreenBodyState.showOnlineConversation(online_ls);
        }
        catch(e){

        };

      });
      socket.on(socketOnlineEvent, (id) {

        try {
          conversationScreenBodyState.onlineUser(id);
          chatScreenState.onlineUser(id);
        }
        catch(e){
        };

      });
      socket.on(socketOfflineEvent, (id) {
        try {
          conversationScreenBodyState.offlineUser(id);
          chatScreenState.offlineUser(id);
        }
        catch(e){
        };
      });
    });
  }
  void sendMessage(Message msg,receiveUserId,currentConversation){
    var socketMsg = msg.toMap();
    socket.emit(socketMessageEvent,{'socketMsg' : socketMsg ,'receiveUserId':receiveUserId} );
    conversationScreenBodyState.handleNewMessageFromCurrent(msg, receiveUserId,currentConversation);
  }

  // void pushNewConverSation(Conversation conversation){
  //   conversationScreenBodyState.handleNewMessage(msg);
  // }

  @override
  String toString() {
    return 'CustomSocket{socket: $socket, currentUserId: $currentUserId, conversationScreenBodyState: $conversationScreenBodyState, chatScreenState: $chatScreenState}';
  }
}
