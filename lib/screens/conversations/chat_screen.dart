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






class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key,required this.conversation}) : super(key: key);
  Conversation conversation;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String currentUserId = '';

  late int currentPage;
  late MessageStreamModel _messageStreamModel;
  late EmojiPicker cachedPicker;
  // Future<void> lm() {
  //   print('on ref');
  //   this.currentPage = this.currentPage + 1;
  //   return _messageStreamModel.loadMore(clearCachedData: false, page: this.currentPage);
  //   // setState((){
  //   //   this.currentPage = this.currentPage + 1;
  //   //   _messageStreamModel.loadMore(clearCachedData: false, page: this.currentPage);
  //   // });
  //
  // }
  @override
  void initState() {
    currentPage = 0;
    _messageStreamModel = MessageStreamModel(widget.conversation.id,widget.conversation);
    cachedPicker = EmojiPicker(
        rows: 4,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          print(emoji);
          setState(() {
            _controller.text = _controller.text + emoji.emoji;
            sendButton = true;
          });
        });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        this.currentPage = this.currentPage + 1;
        _messageStreamModel.loadMore(page: this.currentPage);
      }
    });


    getCurrentUserId().then((value){
      currentUserId  =value;

      setState((){
        return;
      });
    });
    globalCustomSocket.initChatScreenState(this);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    super.initState();
  }

  void handleNewMessage(Message msg){
    if (!msg.checkMsgUserId(widget.conversation.partnerUser!.id)) {
      return;
    }
    setState((){
      return;
    });
  }
  // void handleNewMessageFromCurrent(Message msg){
  //   setState((){
  //     return;
  //   });
  // }
  void sendMessage(String text) async {
    var chatId =  widget.conversation.id;
    var receiveUserId = widget.conversation.partnerUser!.id;
    Message sentMsg = await sendMessageAPI(text, chatId, receiveUserId );
    if(sentMsg.id != '') {
      globalCustomSocket.sendMessage(sentMsg,receiveUserId);
      setState((){
        sendButton = false;
      });
      // if (_scrollController.position.pixels != 0) {
      //   _scrollController.animateTo(
      //       _scrollController
      //           .position.minScrollExtent,
      //       duration:
      //       Duration(milliseconds: 300),
      //       curve: Curves.easeOut);
      // }
    }

  }
  Future<void> nth(){
    return Future.value();
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
                        "Last seen just now",
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    // height: MediaQuery.of(context).size.height - 150,
                    child: StreamBuilder(
                          stream: _messageStreamModel.stream,
                          builder:(BuildContext _context,AsyncSnapshot _snapshot){

                          if (!_snapshot.hasData){
                              return Center(child: CircularProgressIndicator());
                          } else{
                            // loadMore(_snapshot.data);
                            print('current ms ls');
                            print(widget.conversation.messages.length);
                            return RefreshIndicator(
                              onRefresh: nth,
                              child:ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: widget.conversation.messages.length + 2,
                                itemBuilder: (context, ind)  {
                                  int index = ind - 1;
                                  if (index ==  -1 ) {
                                    return Container(
                                      height: 70,
                                    );
                                  }else if (index == widget.conversation.messages.length  && _messageStreamModel.hasMore){
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 32.0),
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  } else if (index == widget.conversation.messages.length  && !_messageStreamModel.hasMore){
                                    return Container();
                                  }
                                  if ( widget.conversation.messages[index].checkMsgUserId(this.currentUserId)) {
                                    return OwnMessageCard(
                                      message:  widget.conversation.messages[index].content.toString(),
                                      time: dateTimeFormat( widget.conversation.messages[index].createdAt.toString()),
                                    );
                                  } else {

                                    return Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          CircleAvatar(
                                            backgroundImage:  getImageProviderNetWork(widget.conversation.partnerUser!.avatar!.fileName),
                                            radius: 12,
                                          ),
                                          ReplyCard(
                                            message:  widget.conversation.messages[index].content.toString(),
                                            time: dateTimeFormat( widget.conversation.messages[index].createdAt.toString()),
                                          )
                                        ]
                                    );
                                  }
                                },
                              )
                            );
                          }
                      }
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height:70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    controller: _controller,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      print(value);
                                      if (value.length > 0) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          show
                                              ? Icons.keyboard
                                              : Icons.emoji_emotions_outlined,
                                        ),
                                        onPressed: () {
                                          if (!show) {
                                            focusNode.unfocus();
                                            focusNode.canRequestFocus = false;
                                          }
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.attach_file),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                  Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                      bottomSheet());
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            onPressed: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (builder) =>
                                              //             CameraApp()));
                                            },
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 2,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Color(0xFF128C7E),
                                  child: IconButton(
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.mic,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (sendButton) {
                                        sendMessage(
                                            _controller.text);
                                        _controller.clear();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //       children: [
                  //         show ? cachedPicker : Container(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  // Widget emojiSelect() {
  //   return EmojiPicker(
  //       rows: 4,
  //       columns: 7,
  //       onEmojiSelected: (emoji, category) {
  //         print(emoji);
  //         setState(() {
  //           _controller.text = _controller.text + emoji.emoji;
  //         });
  //       });
  // }
}


class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({Key? key, required this.message,required this.time}) : super(key: key);
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
          minWidth: 200,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                  left: 10,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  const ReplyCard({Key? key, required this.message, required this.time}) : super(key: key);
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
          minWidth: 180,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 20,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}