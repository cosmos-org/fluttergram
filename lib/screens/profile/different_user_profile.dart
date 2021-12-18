import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/controllers/home/post_controller.dart';
import 'package:fluttergram/controllers/user_controller.dart';
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
  void choiceAction(String choice) {
    if (choice == Constants.Block) {
      print('Block user');
    }
  }

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

Widget profileHeaderWidget(
    BuildContext context, Profile profile, String status, Function callback) {
  void choiceAction(String choice) {
    if (choice == Constants.Block) {
      print("Block user");
    }
  }

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
        Navigator.of(context).pop();
        callback('Add friend');
        await removeFriend(profile.user.id);
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
        callback('Remove friend');
        Navigator.of(context).pop();
        await acceptFriend(profile.user.id, "1");
      },
    );

    Widget noButton = TextButton(
      child: Text("No", style: TextStyle(color: textColor)),
      onPressed: () async{
        Navigator.of(context).pop();
        callback('Add friend');
        await acceptFriend(profile.user.id, "2");
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

  return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(profile.user.username),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
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
                              case 'Remove friend':
                                String username = profile.user.username;
                                removeFriendAlert(context, 'Do you want to remove $username from your friend list?');
                                break;
                              case 'Add friend':
                                buttonText = 'Cancel request';
                                callback(buttonText);
                                await requestFriend(profile.user.id);
                                break;
                              case 'Accept friend':
                                String username = profile.user.username;
                                acceptFriendAlert(context, 'Do you want to accept $username?');
                                break;
                              case 'Cancel request':
                                buttonText = 'Add friend';
                                callback(buttonText);
                                await removeRequestFriend(profile.user.id);
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
  if (status == 'Remove friend') {
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
  if (status == 'Remove friend') {
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

// class ActionButton extends StatefulWidget {
// class ActionButton extends StatefulWidget {
//   String status;
//   Profile profile;
//   ActionButton(this.profile, this.status);
//   @override
//   State<StatefulWidget> createState() => ActionButtonState(profile, status);
// }
//
// class ActionButtonState extends State<ActionButton> {
//   Profile profile;
//   String status;
//   ActionButtonState(this.profile, this.status);
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: Text(status, style: TextStyle(color: Colors.black)),
//             ),
//             style: OutlinedButton.styleFrom(
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 minimumSize: Size(0, 30),
//                 side: BorderSide(
//                   color: primaryColor,
//                 )),
//             onPressed: () {
//               String buttonText = '';
//               switch (status) {
//                 case 'Remove friend'://push alert, push again
//                   String username = profile.user.username;
//                   removeFriendAlert(context, 'Do you want to remove $username from your friend list?');
//                   break;
//                 case 'Add friend'://oke
//                   buttonText = 'Friend requested';
//                   break;
//                 case 'Accept friend'://push again
//                   buttonText = 'Remove friend';
//                   break;
//                 case 'Cancel request':
//                   buttonText = 'Add friend';
//                   break;
//                 case 'Friend requested':
//                   buttonText = 'Add friend';
//                   break;
//               }
//               ;
//               setState(() {
//                 status = buttonText;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

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


