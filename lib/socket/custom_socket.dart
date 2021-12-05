import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../screens/conversations/conversation_screen.dart';
import '../screens/conversations/chat_screen.dart';
import '../util/util.dart';
// void passKeyConversation(CustomSocket customSocket, GlobalKey<>){
//
// }

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
  late ConversationScreenState conversationScreenState;
  late ChatScreenState chatScreenState;
  void initConversationState(ConversationScreenState t){
    this.conversationScreenState = t;
  }
  void initChatState(ChatScreenState  t){
    this.chatScreenState = t;
  }
  void handleNewMessageForConvesation(msg){
    //push new conversation or add message here
    // this.conversationScreenState.convesations.push(msg)
    // conversationScreenState.callSetState();
  }
  void handleNewMessageForChat(msg){
    //add msg
  }
  void connect(){
    socket = IO.io(socketHostname, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit(socketSignInEvent, this.currentUserId);
    socket.onConnect((data) {
      socket.on(socketMessageEvent, (msg) {
        handleNewMessageForConvesation(msg);
        handleNewMessageForChat(msg);
      });
    });
  }
  void sendMessage(String receiverId, String content){
    SocketMsg socketMsg = SocketMsg(this.currentUserId, receiverId, content);
    socket.emit(socketMessageEvent,socketMsg);
  }

  CustomSocket(this.currentUserId);

  @override
  String toString() {
    return 'CustomSocket{socket: $socket, currentUserId: $currentUserId, conversationScreenState: $conversationScreenState, chatScreenState: $chatScreenState}';
  }
}

class SocketMsg{
  String from;
  String to;
  String content;

  SocketMsg(this.from, this.to, this.content);
}