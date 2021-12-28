import 'package:flutter/material.dart';
import 'package:fluttergram/screens/profile/friend_requests.dart';
import 'package:fluttergram/screens/profile/list_friends.dart';
import 'package:fluttergram/screens/profile/sent_requests.dart';

import '../../constants.dart';
import '../../default_screen.dart';

class FriendsScreen extends StatefulWidget {
  int currentTab;
  FriendsScreen({Key? key, required this.currentTab}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FriendsState(currentTab);
}

class FriendsState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  int _currentTab;
  bool state = true;
  // late TabController _tabController;
  FriendsState(this._currentTab);

  // @override
  // void initState() {
  //   _tabController = TabController(vsync: this, length: 3);
  //   _tabController.index = _currentTab;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: _currentTab,
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
            // controller: _tabController,
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
        onTap: (index) {});
  }
}
