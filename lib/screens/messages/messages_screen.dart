import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/models/chat.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'search_messages_screen.dart';
import 'new_message_screen.dart';


class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.chat,
    // required this.onPressed
  }) : super(key: key);

  final Chat chat;
  // final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}


class MessageScreenBody extends StatelessWidget {
  const MessageScreenBody({Key? key}) : super(key: key);

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
        child: Card(child: Message(chat: chatsData[index]))
      ),
    );
  }
}


class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _selectedScreen = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: MessageScreenBody(),
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

