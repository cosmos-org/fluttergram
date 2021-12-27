import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../../constants.dart';
import 'different_user_profile.dart';
import 'friend_card.dart';

class SentRequestsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SentRequestsState();
}

class SentRequestsState extends State<SentRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getListUsersSentRequest(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<User> sentRequests = snapshot.data;
            return Container(
                child: ListView.builder(
              itemCount: sentRequests.length,
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
                    Profile friendProfile =
                        await showAnotherProfile(sentRequests[index].id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DUserProfileScreen(
                                profile: friendProfile,
                                status: "Cancel Request")));
                  },
                  child: FriendCard(friend: sentRequests[index], tabIndex: 3)),
            ));
          }
        });
  }
}