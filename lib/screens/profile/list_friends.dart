import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile/friend_card.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../../constants.dart';
import 'different_user_profile.dart';

class ListFriendsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListFriendState();
}

class ListFriendState extends State<ListFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFriends(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<User> friends = snapshot.data;
            return Container(
                child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (_, index) => FocusedMenuHolder(
                  blurSize: 0.3,
                  blurBackgroundColor: secondaryColor,
                  menuWidth: 200,
                  menuItems: <FocusedMenuItem>[
                    FocusedMenuItem(
                        title: Text("Unfriend",
                            style: TextStyle(color: errorColor)),
                        onPressed: () {
                          removeFriend(friends[index].id);
                          setState(() {
                            friends.remove(index);
                          });
                        }),
                  ],
                  onPressed: () async {
                    Profile friendProfile =
                        await showAnotherProfile(friends[index].id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DUserProfileScreen(
                                profile: friendProfile, status: "Message")));
                  },
                  child: FriendCard(friend: friends[index], tabIndex: 1)),
            ));
          }
        });
  }
}
