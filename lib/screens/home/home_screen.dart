import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/home/post.dart';
import 'package:fluttergram/screens/home/story.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: FutureBuilder<List<User>>(
          future: getFriends(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // data loaded:
              final friends = snapshot.data!;
              return CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          color: Colors.white,
                          child: Text(
                            'Stories',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    ),
                    SliverToBoxAdapter(
                        child: Story(currentUser: friends[0],friends: friends)
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          color: Colors.white,
                          child: Text(
                            'Lastest Feed',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    ),
                    SliverToBoxAdapter(
                      child: Posts(),
                    )
                  ]
              );
            }
          },
        )
    );
  }
  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: primaryColor,
        title:  Center(
          child: Text('COSMOS'),
        ),
        leading: IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () {},
          ),
        ]);
  }
}
