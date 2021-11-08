import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/models/conversation.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'search_conversation_screen.dart';
import 'new_conversation_screen.dart';


class ConversationCard extends StatelessWidget {
  const ConversationCard({
    Key? key,
    required this.chat,
    // required this.onPressed
  }) : super(key: key);

  final Conversation chat;
  // final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: secondaryColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding*0.75),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(chat.avatar),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: TextStyle(fontSize: usernameFontSize, fontWeight: boldFontWeight),
                      ),
                      SizedBox(height: defaultPadding*0.25),
                      Text(
                        chat.messagePreview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: chat.isSeen ? normalFontWeight : boldFontWeight),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: defaultPadding*0.25),
                  Text(
                    chat.lastMessageTime,
                    style: TextStyle(fontSize: 12.0, fontWeight: normalFontWeight)
                  ),
                  SizedBox(height: defaultPadding*0.1),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: chat.isActive ? primaryColor : secondaryColor,
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
  const ConversationScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, index) => FocusedMenuHolder(
        blurSize: 0.3,
        blurBackgroundColor: secondaryColor,
        menuWidth: 200,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(title: Text("Block", style: TextStyle(color: errorColor)), onPressed: () {}),
          FocusedMenuItem(title: Text("Turn off notification"), onPressed: () {}),
        ],
        onPressed: () {},
        child: ConversationCard(chat: CONVERSATIONS[index])
      ),
    );
  }
}


class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  int _selectedScreen = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ConversationScreenBody(),
      bottomNavigationBar: buildBottomNavbar(),
    );
  }

  AppBar buildAppBar(){
    return AppBar(
      backgroundColor: primaryColor,
      leading: BackButton(),
      title: Text("Messages"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewMessageScreen())
            );
          },
          icon: Icon(Icons.note_add)),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchMessagesScreen())
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        )
      ]
    );
  }

  BottomNavigationBar buildBottomNavbar(){
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedScreen,
      fixedColor: primaryColor,
      onTap: (value) {
        setState(() {
          _selectedScreen = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

