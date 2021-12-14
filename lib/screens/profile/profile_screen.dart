import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/home/post.dart';
import 'package:fluttergram/screens/home/upload_post.dart';
import 'package:fluttergram/screens/login/login_screen.dart';
import 'package:fluttergram/screens/profile/change_password.dart';
import 'package:fluttergram/util/util.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void choiceAction(String choice){
    if(choice == Constants.Changepassword){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePassword()
          )
      );
    }else if(choice == Constants.SignOut){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LogInPage()),
          ModalRoute.withName('/')
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      future: show(),
      builder: (ctx, snapshot){
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          final profile = snapshot.data!;
          return profileHeaderWidget(context, profile);
        }
      }
    );
  }
}

class Constants {
  static const String Changepassword = 'Change password';
  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[
    Changepassword,
    SignOut
  ];
}

Widget profileHeaderWidget(BuildContext context, Profile profile) {
  void choiceAction(String choice){
    if(choice == Constants.Changepassword){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePassword()
          )
      );
    }else if(choice == Constants.SignOut){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LogInPage()
          ),
          ModalRoute.withName("/Login")
      );
    }
  }
  return Scaffold(
    appBar: AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      title: Text(profile.user.username),
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
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: choiceAction,
          itemBuilder: (BuildContext context){
            return Constants.choices.map((String choice){
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ],
    ),
    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
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
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xff74EDED),
                  backgroundImage:
                  getImageProviderNetWork(profile.user.avatar!.fileName),
                ),
                Row(
                  children: [
                    Column(
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
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text(
                          profile.numFriends.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Friends",
                          style: TextStyle(
                            letterSpacing: 0.4,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
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
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                )
              ],
            ),
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
            actions(context, profile.user),
            SizedBox(
              height: 20,
            ),
            Container(
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
            ),
            Expanded(
              child: Posts(),
            )
          ],
        ),
      ),
    )
  );
}

Widget actions(BuildContext context, User user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: OutlinedButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text("Edit Profile", style: TextStyle(color: Colors.black)),
          ),
          style: OutlinedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size(0, 30),
              side: BorderSide(
                color: primaryColor,
              )),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile(user: user))
            );
          },
        ),
      ),
    ],
  );
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


