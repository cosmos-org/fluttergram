import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/controllers/home/post_controller.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/default_screen.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/screens/home/post.dart';
import 'package:fluttergram/util/util.dart';

class DUserProfileScreen extends StatefulWidget {
  Profile profile;
  String status;
  DUserProfileScreen({Key? key, required this.profile, required this.status})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(profile, status);
}

class _ProfileScreenState extends State<DUserProfileScreen> {
  Profile _profile;
  String status;

  void callback (String statusAfter){
    setState((){
      status = statusAfter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return profileHeaderWidget(context, _profile, status, this.callback);
  }

  _ProfileScreenState(this._profile, this.status);
}

class Constants {
  static const String Block = 'Block';
  static const List<String> choices = <String>[Block];
}

class Constants_friend {
  static const String Block = 'Block';
  static const String RemoveFriend = 'Remove fiend';
  static const List<String> choices = <String>[Block, RemoveFriend];
}

Widget profileHeaderWidget(
  BuildContext context, Profile profile, String status, Function callback) {
    removeFriendAlert(BuildContext context, String message) {
      Color textColor = primaryColor;
      Widget cancelButton = TextButton(
        child: Text("Cancel", style: TextStyle(color: textColor)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

    Widget okButton = TextButton(
      child: Text("Ok", style: TextStyle(color: textColor)),
      onPressed: () async{
        if (await removeFriend(profile.user.id)){
          Navigator.of(context).pop();
          callback('Add friend');
        };
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: secondaryColor,
      title: Text(message, style: TextStyle(color: textColor)),
      actions: [
        okButton,
        cancelButton
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

    blockUserAlert(BuildContext context, String message) {
      Color textColor = primaryColor;
      Widget cancelButton = TextButton(
        child: Text("Cancel", style: TextStyle(color: textColor)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      Widget okButton = TextButton(
        child: Text("Ok", style: TextStyle(color: textColor)),
        onPressed: () async{
          if (await blockUser(profile.user.id, "true")){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => DefaultScreen(currentScreen: 0)),
                ModalRoute.withName('/'));
          };
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        backgroundColor: secondaryColor,
        title: Text(message, style: TextStyle(color: textColor)),
        actions: [
          okButton,
          cancelButton
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

  acceptFriendAlert(BuildContext context, String message) {
    Color textColor = primaryColor;
    Widget yesButton = TextButton(
      child: Text("Yes", style: TextStyle(color: textColor)),
      onPressed: () async {
        if (await acceptFriend(profile.user.id, "1")){
          callback('Message');
          Navigator.of(context).pop();
        };
      },
    );

    Widget noButton = TextButton(
      child: Text("No", style: TextStyle(color: textColor)),
      onPressed: () async{
        if (await acceptFriend(profile.user.id, "2")){
          Navigator.of(context).pop();
          callback('Add friend');
        };
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: secondaryColor,
      title: Text(message, style: TextStyle(color: textColor)),
      actions: [
        yesButton,
        noButton
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

    void choiceAction(String choice) {
      if (choice == Constants.Block) {
        String username = profile.user.username;
        blockUserAlert(context, 'Do you want block $username?');
      }
      if (choice == Constants_friend.RemoveFriend) {
        String username = profile.user.username;
        removeFriendAlert(context, 'Do you want to remove $username from your friend list?');
      }
    }

  return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(profile.user.username),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return status != 'Message' ?
                Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList() :
              Constants_friend.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xff74EDED),
                          backgroundImage: getImageProviderNetWork(
                              profile.user.avatar!.fileName),
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              profile.numPosts.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Posts",
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 0.4,
                              ),
                            )
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              profile.user.gender!,
                              style: TextStyle(
                                letterSpacing: 0.4,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Gender",
                              style: TextStyle(
                                letterSpacing: 0.4,
                                fontSize: 15,
                              ),
                            )
                          ],
                        )),
                      ]),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    profile.user.username,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    profile.user.description!,
                    style: TextStyle(
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // ActionButton(profile ,status),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Text(status, style: TextStyle(color: Colors.black)),
                          ),
                          style: OutlinedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(0, 30),
                            side: BorderSide(
                              color: primaryColor,
                            )),
                          onPressed: () async{
                            String buttonText = '';
                            switch (status) {
                              case 'Message':
                                //Di chuyen den screen chat cua 2 nguoi
                                // HUYDQ
                                break;
                              case 'Add friend':
                                if (await requestFriend(profile.user.id)){
                                  buttonText = 'Cancel request';
                                  callback(buttonText);
                                };
                                break;
                              case 'Accept friend':
                                String username = profile.user.username;
                                acceptFriendAlert(context, 'Do you want to accept $username?');
                                break;
                              case 'Cancel request':
                                if (await removeRequestFriend(profile.user.id)){
                                  buttonText = 'Add friend';
                                  callback(buttonText);
                                };
                                break;
                            };
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  story(status),
                  myPost(profile.user.id, status),
                ],
              )),
        ),
      ));
}

Widget story(String status) {
  if (status == 'Message') {
    return Container(
      height: 85,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: highlightItems.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage(highlightItems[index].thumbnail),
                        radius: 28,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      highlightItems[index].title,
                      style: TextStyle(fontSize: 13),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              )
            ],
          );
        },
      ),
    );
  } else
    return SizedBox.shrink();
}

Widget myPost(String userId, String status) {
  if (status == 'Message') {
    return FutureBuilder<List<Post>>(
        future: getPostsByUserId(userId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          ;
          if (snapshot.hasError) {
            return Text("Error");
          }
          ;
          List<Post> list = snapshot.data as List<Post>;
          // return PostContainer(post: list[0]);
          return Wrap(
            spacing: 10, // set spacing here
            children: createPostList(list, 3),
          );
        });
  } else
    return SizedBox.shrink();
}

class Highlight {
  String thumbnail;
  String title;
  Highlight({required this.thumbnail, required this.title});
}

List<Highlight> highlightItems = [
  Highlight(thumbnail: 'assets/images/bike.jpg', title: "My Bike 🏍"),
  Highlight(thumbnail: 'assets/images/cooking.jpg', title: "Cooking 🔪"),
  Highlight(thumbnail: 'assets/images/nature.jpg', title: "Nature 🏞"),
  Highlight(thumbnail: 'assets/images/pet.jpg', title: "Pet ❤️"),
  Highlight(thumbnail: 'assets/images/swimming.jpg', title: "Pool 🌊"),
  Highlight(thumbnail: 'assets/images/yoga.jpg', title: "Yoga 💪🏻"),
];


