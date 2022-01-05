import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/util/util.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../../constants.dart';
import 'friend_card.dart';

class BlockList extends StatefulWidget {
  final List<User> blockedUsers;
  BlockList(this.blockedUsers);
  @override
  State<StatefulWidget> createState() => BlockListState(blockedUsers);
}

class BlockListState extends State<BlockList>
    with SingleTickerProviderStateMixin {
  List<User> blockedUsers;

  BlockListState(this.blockedUsers);

  void removeUserFromBlock(int index) {
    setState(() {
      blockedUsers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: blockedUsers.length,
                itemBuilder: (_, index) =>
                    FocusedMenuHolder(
                      blurSize: 0.3,
                      blurBackgroundColor: secondaryColor,
                      menuWidth: 200,
                      menuItems: <FocusedMenuItem>[],
                      onPressed: () {},
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                BorderSide(color: secondaryColor)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                                vertical: defaultPadding * 0.75),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                  getImageProviderNetWork(
                                      blockedUsers[index]
                                          .avatar
                                          ?.fileName
                                          .toString()),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          blockedUsers[index]
                                              .username
                                              .toString(),
                                          style: TextStyle(
                                              fontSize:
                                              usernameFontSize,
                                              fontWeight:
                                              boldFontWeight),
                                        ),
                                        SizedBox(
                                            height:
                                            defaultPadding * 0.25),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.0))),
                                                backgroundColor: MaterialStateProperty.all(primaryColor)),
                                            onPressed: () async {
                                              String currentId = await getCurrentUserId();
                                              unblockAlert(currentId, index);
                                              // blockUser(currentId, "false");
                                              // removeUserFromBlock(index);
                                            },
                                            child: Text(
                                              "Unblock",
                                              style: TextStyle(color: secondaryColor),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))));
  }

  unblockAlert(String currentId, int index){
    Color textColor = primaryColor;
    // set up the button
    Widget okButton = TextButton(
      child: Text("Unblock", style: TextStyle(color: errorColor)),
      onPressed: () async {
        Navigator.of(context).pop();
        String currentId = await getCurrentUserId();
        blockUser(currentId, "false");
        removeUserFromBlock(index);
      },
    );

    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: primaryColor)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: secondaryColor,
      title: Text("Are you sure to unblock this person?", style: TextStyle(color: textColor)),
      actions: [
        cancelButton,
        okButton
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
}
