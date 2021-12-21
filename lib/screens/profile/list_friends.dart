import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../default_screen.dart';

class ListFriendScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListFriendState();
}

class ListFriendState extends State<ListFriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text("Friends"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: secondaryColor,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DefaultScreen(currentScreen: 3)),
                ModalRoute.withName('/'));
          },
        ),
      ),
    );
  }
}
