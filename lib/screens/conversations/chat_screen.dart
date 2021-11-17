import 'package:flutter/material.dart';
import 'package:fluttergram/models/conversation_model.dart';
import '../../models/user_model.dart';
// Controllers
import '../../controllers/conversation_controller.dart';
// Others
import '../../constants.dart';

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
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
              itemBuilder: (_, index) => Text(conversation.messages[index]));
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(),
      title: Text(widget.user.name),
    );
  }
}
