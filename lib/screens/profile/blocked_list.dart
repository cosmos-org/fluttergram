import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/util/util.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../../constants.dart';
import 'friend_card.dart';

class BlockList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BlockListState();
}

class BlockListState extends State<BlockList>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getBlockList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  centerTitle: true,
                  title: Text("Block List",
                      style: TextStyle(color: secondaryColor)),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: secondaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Container(child: CircularProgressIndicator()));
          } else {
            List<User> blockList = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  centerTitle: true,
                  title: Text("Block List",
                      style: TextStyle(color: secondaryColor)),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: secondaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Container(
                    child: ListView.builder(
                  itemCount: blockList.length,
                  itemBuilder: (_, index) => FocusedMenuHolder(
                      blurSize: 0.3,
                      blurBackgroundColor: secondaryColor,
                      menuWidth: 200,
                      menuItems: <FocusedMenuItem>[
                        FocusedMenuItem(
                            title: Text("Unblock",
                                style: TextStyle(color: primaryColor)),
                            onPressed: () async {
                              String currentId = await getCurrentUserId();
                              blockUser(currentId, "false");
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BlockList()),
                                  ModalRoute.withName('/'));
                            }),
                      ],
                      onPressed: () {},
                      child: FriendCard(friend: blockList[index], tabIndex: 4)),
                )));
          }
        });
  }
}
