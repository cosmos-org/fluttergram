import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile/friend_requests.dart';
import 'package:fluttergram/screens/profile/list_friends.dart';
import 'package:fluttergram/screens/profile/sent_requests.dart';

import '../../constants.dart';
import '../../default_screen.dart';

class FriendsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FriendsState();
}

class FriendsState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            centerTitle: true,
            title: Text("Friends", style: TextStyle(color: secondaryColor)),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: secondaryColor,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DefaultScreen(currentScreen: 3)),
                    ModalRoute.withName('/'));
              },
            ),
            bottom: createTabBar(),
          ),
          body: TabBarView(
            children: [
              ListFriendsScreen(),
              AwaitRequestsScreen(),
              SentRequestsScreen()
            ],
          ),
        ));
  }

  TabBar createTabBar() {
    return TabBar(
        labelStyle: TextStyle(fontSize: 15),
        tabs: [
          Icon(Icons.people_sharp),
          Icon(Icons.person_add_alt_1_sharp),
          Icon(Icons.arrow_forward_sharp)
        ],
        onTap: (index) {
        });
  }
}
