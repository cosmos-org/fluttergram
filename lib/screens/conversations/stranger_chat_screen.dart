import 'package:flutter/material.dart';
import 'package:fluttergram/models/conversation_model.dart';
import 'package:fluttergram/models/message_model.dart';
import '../../models/user_model.dart';
// Controllers
import '../../controllers/conversation/conversation_controller.dart';
// Others
import '../../constants.dart';
import '../../util/util.dart';
import '../../socket/custom_socket.dart';
import 'package:emoji_picker/emoji_picker.dart';
import '../../controllers/conversation/message_stream_controller.dart';





class StrangerChatScreen extends StatefulWidget {
  StrangerChatScreen({Key? key,required this.conversation}) : super(key: key);
  Conversation conversation;

  @override
  StrangerChatScreenState createState() => StrangerChatScreenState();
}

class StrangerChatScreenState extends State<StrangerChatScreen> {
  late String currentUserId;
  @override
  void initState() {
    getCurrentUserId().then((value){
      currentUserId  =value;
      setState((){
        return;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      backgroundImage:  getImageProviderNetWork(widget.conversation.partnerUser!.avatar!.fileName),
                      radius: 20,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.conversation.partnerUser!.username,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Not connected",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
                IconButton(icon: Icon(Icons.call), onPressed: () {}),
                PopupMenuButton<String>(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("View Contact"),
                        value: "View Contact",
                      ),
                      PopupMenuItem(
                        child: Text("Media, links, and docs"),
                        value: "Media, links, and docs",
                      ),
                      PopupMenuItem(
                        child: Text("Fluttergram Web"),
                        value: "Fluttergram Web",
                      ),
                      PopupMenuItem(
                        child: Text("Search"),
                        value: "Search",
                      ),
                      PopupMenuItem(
                        child: Text("Mute Notification"),
                        value: "Mute Notification",
                      ),
                      PopupMenuItem(
                        child: Text("Wallpaper"),
                        value: "Wallpaper",
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Column(
                  children: [
                    Text('Become friends to chat together!'),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused))
                                return Colors.red;
                              return null; // Defer to the widget's default.
                            }
                        ),
                      ),
                      onPressed: () {
                        print('send friend request');
                      },
                      child: Text('Send friend request!'),
                    ),
                  ]
                )
            ),
          ),
        ),
      ],
    );
  }


}

