import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/conversation_model.dart';
import 'package:fluttergram/models/message_model.dart';
import '../../models/user_model.dart';
// Controllers
import '../../controllers/conversation/conversation_controller.dart';
import '../../controllers/friends/friend_controller.dart';
// Others
import '../../constants.dart';
import '../../util/util.dart';
import '../../socket/custom_socket.dart';

import 'chat_screen.dart';

class StrangerChatScreen extends StatefulWidget {
  StrangerChatScreen({Key? key, required this.conversation}) : super(key: key);
  Conversation conversation;

  @override
  StrangerChatScreenState createState() => StrangerChatScreenState();
}

class StrangerChatScreenState extends State<StrangerChatScreen> {
  late String currentUserId;

  @override
  void initState() {
    getCurrentUserId().then((value) {
      currentUserId = value;
      setState(() {
        return;
      });

    });


    super.initState();
  }
  void _acceptFriend(BuildContext ctx) async{
    var acceptSuccess = await acceptFriendAPI( widget.conversation.partnerUser!.id, "1");
    if (acceptSuccess[0] == true) {
      Conversation conversation = acceptSuccess[1];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (contex) => ChatScreen(
              conversation: conversation,
            )),
      );
    } else {
      alertShow(ctx, "error", "Accept friend request error.", "Retry");
    }
  }

  void _refuseFriend(BuildContext ctx)  async{
    var refuseSuccess = await acceptFriendAPI( widget.conversation.partnerUser!.id, "2");
    if (refuseSuccess[0] == true) {
      setState(() {});
    } else {
      alertShow(ctx, "error", "Refuse friend request error.", "Retry");
    }
  }

  void _sendRequest(BuildContext ctx) async{
    var refuseSuccess = await requestFriendAPI( widget.conversation.partnerUser!.id);
    if (refuseSuccess == true) {
      setState(() {});
    } else {
      alertShow(ctx, "error", "Send friend request error.", "Retry");
    }
  }

  void _cancelRequest(BuildContext ctx) async{
    var refuseSuccess = await removeRequestFriendAPI( widget.conversation.partnerUser!.id);
    if (refuseSuccess == true) {
      setState(() {});
    } else {
      alertShow(ctx, "error", "Cancel friend request error.", "Retry");
    }
  }

  Widget customButton(String text, callback,BuildContext ctx) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) return Colors.red;
              return null; // Defer to the widget's default.
            }),
      ),
      onPressed: () {
        callback(ctx);
      },
      child: Text(text),
    );
  }
  List<Widget> buildBody(BuildContext ctx, String value){
    var UIMap = {
      'Remove friend': [Text('Friends Already!')],
      'Accept friend': [
        Text(widget.conversation.partnerUser!.username +
            'has sent you a friend request!'),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customButton('Accept  ', _acceptFriend,ctx),
              customButton('Refuse', _refuseFriend,ctx),
            ])
      ],
      'Cancel request':[
        Text('You have sent friend request to ' +widget.conversation.partnerUser!.username +' !'),
        customButton('Cancel', _cancelRequest,ctx),
      ],
      'Add friend': [
        Text('Become friends to chat together!'),
        customButton('Send friend request', _sendRequest,ctx),
      ],
    };
    return UIMap[value] ?? [Container()];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStatusUser_(widget.conversation.partnerUser!.id),
      builder: (ctx,_snapshot) {
        if (_snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator()
          );
        }
        ;
        if (_snapshot.hasError) {
          return Center(child:Text("Error"));
        }
        ;
        String friendStatusValue  = _snapshot.data as String;
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
                            backgroundImage: getImageProviderNetWork(
                                widget.conversation.partnerUser!.avatar!.fileName),
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
                body: Center(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: buildBody(ctx, friendStatusValue),
                        )),
                  ),
                )),
          ],
        );
      }
    );
  }
}



alertShow(BuildContext context, String type, String message, String button) {
  Color textColor = primaryColor;
  switch (type) {
    case "error":
      textColor = errorColor;
      break;
    case "warning":
      textColor = warningColor;
      break;
  }
  // set up the button
  Widget okButton = TextButton(
    child: Text(button, style: TextStyle(color: textColor)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: secondaryColor,
    title: Text(message, style: TextStyle(color: textColor)),
    // content: const Text("You have created a new COSMOS account!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}