import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/home/post.dart';
import 'package:fluttergram/screens/home/story.dart';
import 'package:fluttergram/screens/home/upload_post.dart';
import '../../constants.dart';
import 'create_post.dart';

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
              return FutureBuilder<User>(
              future: getCurrentUser(),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                    if (!snapshot.hasData) {
                    // while data is loading:
                      return const Center(
                      child: CircularProgressIndicator(),
                      );
                    } else {
                      // data loaded:
                      User currentUser = snapshot.data!;

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:[
                            Container(
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
                                ),
                            Story(currentUser: currentUser,friends: friends),
                            Container(
                                  padding: const EdgeInsets.all(2.0),
                                  color: Colors.white,
                                  child: Text(
                                    'Latest Feed',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            Expanded(
                              child: Posts(),
                            )
                          ]
                      );
                    }
              },
              );
              }
        }
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePost()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () {},
          ),
        ]);
  }
}
