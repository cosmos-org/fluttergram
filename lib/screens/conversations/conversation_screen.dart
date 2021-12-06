import 'package:flutter/material.dart';
import 'package:fluttergram/models/message_model.dart';
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
import '../../util/util.dart';
import '../../socket/custom_socket.dart';
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
                backgroundImage: getImageProviderNetWork(conversation.partnerUser?.avatar?.fileName.toString()),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.partnerUser?.username.toString() ?? '',
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

class ConversationScreenBody extends StatefulWidget {
  List<Conversation> conversations;
  ConversationScreenBody({Key? key, required this.conversations})
      : super(key: key);
  @override
  State<ConversationScreenBody> createState() => ConversationScreenBodyState();
}

class ConversationScreenBodyState extends State<ConversationScreenBody> {
  // final List<Conversation> conversations;
  // ConversationScreenBodyState({Key? key, required this.conversations});
  @protected
  void initState() {
    globalCustomSocket.initConversationState(this);
  }
  // bool checkNewConverSation(Message msg){
  //   String fromUserId = msg.user!.id;
  //   List<Conversation> conversationFoundLs = widget.conversations.where((c) => c.partnerUser?.id == fromUserId).toList();
  //   if (conversationFoundLs.length > 0){
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  void handleNewMessage(Message msg){
    void updateAConversation(Conversation conversation, Message msg){
      conversation.lastMessageTime = msg.updatedAt;
      conversation.messagePreview = msg.content;
      conversation.messages.insert(0, msg);
    }
    void deleteConversation(Conversation conversation) {
      widget.conversations.removeWhere((c) => c == conversation);
    }
    void putConversationFirst(Conversation conversation) {
      deleteConversation(conversation);
      widget.conversations.insert(0, conversation);
    }
    void addConversation(Conversation conversation) {
      if (widget.conversations.contains(conversation)) {
        putConversationFirst(conversation);
        return;
      }
      widget.conversations.insert(0, conversation);
    }
    String fromUserId = msg.user!.id;
    List<Conversation> conversationFoundLs = widget.conversations.where((c) => c.partnerUser?.id == fromUserId).toList();
    Conversation conversationFound;
    print('before rebuild');
    print(widget.conversations.length);
    if (conversationFoundLs.length > 0){
      conversationFound = conversationFoundLs[0];
      addConversation(conversationFound);
      setState(() {
        updateAConversation(conversationFound, msg);
      });
    } else {
        setState(() async {
          widget.conversations = await getConversationsAPI();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    print(widget.conversations.length);
    return ListView.builder(
      itemCount: widget.conversations.length,
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
            print(index);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (contex) => ChatScreen(
                      conversation: widget.conversations[index],
                    )),
);
          }, // move to chat screen
          child: ConversationCard(conversation: widget.conversations[index])),
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
          future: getConversationsAPI(),
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
        title: Text(
            "Messages",
            textAlign: TextAlign.center,
            ),
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
