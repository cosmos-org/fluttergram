import 'package:flutter/material.dart';

import 'package:fluttergram/models/conversation_model.dart';
import '../../constants.dart';
import '../../util/util.dart';
import 'chat_screen.dart';
import 'stranger_chat_screen.dart';

const String getFileUrl = hostname + '/files/';

class ConversationSearchedList extends StatelessWidget {
  List<Conversation> conversations;
  // List<User> users;

  ConversationSearchedList({Key? key,  required this.conversations});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (_, index) => InkWell(
              onTap: () {
                if (conversations[index].id != '') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) => ChatScreen(
                          conversation: conversations[index],
                        )),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) => StrangerChatScreen(
                          conversation: conversations[index],
                        )),
                  );
                }
              }, // move to chat screen
              child: ConversationSearched(conversation: conversations[index])
          )
      )
    );
  }
}

// List<Widget> createConversationList(userList) {
//   var ls = <Container>[];
//   userList.forEach((ele) {
//     ls.add(new Container(
//         child: Column(children: [
//       ConversationSearched(user: ele),
//       SizedBox(
//         height: 8,
//       ),
//     ])));
//   });
//
//   return ls;
// }

class ConversationSearched extends StatelessWidget {
  final Conversation conversation;
  ConversationSearched({Key? key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return  Container(

      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: defaultPadding),
        child:Row(children: [
          CircleAvatar(
            radius: 40.0,
            child: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.grey[200],
              backgroundImage: getImageProviderNetWork(conversation.partnerUser!.avatar!.fileName),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(conversation.partnerUser!.username,style: TextStyle(
            fontSize: 20,
          ))
        ]),
      )
    );
  }
}
