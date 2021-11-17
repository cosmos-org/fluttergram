import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
// Controllers
import '../../controllers/conversation_controller.dart';
import '../../controllers/user_controller.dart';
// Models
import '../../models/conversation_model.dart';
import '../../models/user_model.dart';
// Views
import 'chat_screen.dart';
// Others
import '../../constants.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard({
    Key? key,
    required this.conversation,
    // required this.onPressed
  }) : super(key: key);

  final Conversation conversation;
  // final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: secondaryColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding * 0.75),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(conversation.avatar),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.name,
                        style: TextStyle(
                            fontSize: usernameFontSize,
                            fontWeight: boldFontWeight),
                      ),
                      SizedBox(height: defaultPadding * 0.25),
                      Text(
                        conversation.messagePreview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: conversation.isSeen
                                ? normalFontWeight
                                : boldFontWeight),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: defaultPadding * 0.25),
                  Text(conversation.lastMessageTime,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: normalFontWeight)),
                  SizedBox(height: defaultPadding * 0.1),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color:
                          conversation.isActive ? primaryColor : secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConversationScreenBody extends StatelessWidget {
  const ConversationScreenBody({Key? key, required this.conversations})
      : super(key: key);

  final List conversations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, index) => FocusedMenuHolder(
          blurSize: 0.3,
          blurBackgroundColor: secondaryColor,
          menuWidth: 200,
          menuItems: <FocusedMenuItem>[
            FocusedMenuItem(
                title: Text("Block", style: TextStyle(color: errorColor)),
                onPressed: () {}),
            FocusedMenuItem(
                title: Text("Turn off notification"), onPressed: () {}),
          ],
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FutureBuilder(
                          future: getUsers(),
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            final users = snapshot.data as List<User>;
                            return ChatScreen(user: users[index]);
                          },
                        )));
          }, // move to chat screen
          child: ConversationCard(conversation: conversations[index])),
    );
  }
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: FutureBuilder(
          future: getConversations(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            ;
            if (snapshot.hasError) {
              return Text("Error");
            }
            ;
            return ConversationScreenBody(
                conversations: snapshot.data as List<Conversation>);
          },
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: primaryColor,
        title: Text("Messages"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ]);
  }
}
