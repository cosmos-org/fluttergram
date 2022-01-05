import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile/different_user_profile.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../../constants.dart';
import 'friend_card.dart';

class AwaitRequestsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AwaitRequestsState();
}

class AwaitRequestsState extends State<AwaitRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getListFriendsRequest(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<User> friendRequests = snapshot.data;
            return Container(
                child: ListView.builder(
              itemCount: friendRequests.length,
              itemBuilder: (_, index) => FocusedMenuHolder(
                  blurSize: 0.3,
                  blurBackgroundColor: secondaryColor,
                  menuWidth: 200,
                  menuItems: <FocusedMenuItem>[
                    FocusedMenuItem(
                        title:
                            Text("Block", style: TextStyle(color: errorColor)),
                        onPressed: () {})
                  ],
                  onPressed: () async {
                    Profile friendRequestProfile =
                        await showAnotherProfile(friendRequests[index].id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DUserProfileScreen(profile: friendRequestProfile, status: 'Accept friend'))
                    );
                  },
                  child: FriendCard(
                    friend: friendRequests[index],
                    tabIndex: 2,
                  )),
            ));
          }
        });
  }
}
