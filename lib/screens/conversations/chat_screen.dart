import 'package:flutter/material.dart';
import 'package:fluttergram/models/conversation_model.dart';
import 'package:fluttergram/models/message_model.dart';
import '../../models/user_model.dart';
// Controllers
import '../../controllers/conversation_controller.dart';
// Others
import '../../constants.dart';
import '../../socket/custom_socket.dart';
class MessageCard extends StatelessWidget {
  const MessageCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.user, required this.messages}) : super(key: key);
  final List<Message> messages;
  final User user;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  void newMsgHandle(SocketMsg msg){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder(
        future: getConversation(user: widget.user),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error");
          }
          final conversation = snapshot.data as Conversation;
          return ListView.builder(
              itemBuilder: (_, index) => Text('conversation.messages[index]'));
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(),
      title: Text(widget.user.username),
    );
  }
}
