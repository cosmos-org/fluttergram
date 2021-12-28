import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile/friends.dart';
import 'package:fluttergram/util/util.dart';

import '../../constants.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({Key? key, required this.friend, required this.tabIndex})
      : super(key: key);
  final User friend;
  final int tabIndex;

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
                backgroundImage:
                    getImageProviderNetWork(friend.avatar?.fileName.toString()),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.username.toString(),
                        style: TextStyle(
                            fontSize: usernameFontSize,
                            fontWeight: boldFontWeight),
                      ),
                      SizedBox(height: defaultPadding * 0.25),
                      details(context, tabIndex),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  details(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 1:
        return SizedBox();
      case 2:
        return Row(
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                    ),
                    backgroundColor: MaterialStateProperty.all(primaryColor)),
                onPressed: () {
                  acceptFriend(friend.id, "1");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FriendsScreen(currentTab: tabIndex - 1)),
                      ModalRoute.withName('/'));
                },
                child: Text(
                  "Accept",
                  style: TextStyle(color: secondaryColor),
                )),
            TextButton(
                onPressed: () {
                  acceptFriend(friend.id, "2");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FriendsScreen(currentTab: tabIndex - 1)),
                      ModalRoute.withName('/'));
                },
                child: Text("Cancel", style: TextStyle(color: primaryColor)))
          ],
        );
      case 3:
        return ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0))),
                backgroundColor: MaterialStateProperty.all(primaryColor)),
            onPressed: () {
              removeRequestFriend(friend.id);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => FriendsScreen(
                            currentTab: tabIndex - 1,
                          )),
                  ModalRoute.withName('/'));
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: secondaryColor),
            ));
    }
  }
}
