import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/home/upload_post.dart';
import 'package:fluttergram/util/util.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
          return buildApp(profile);
        }
      }
    );
  }

  Widget buildImage({required String path}) {
    final image = getImageProviderNetWork(path);
    return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
          ),
        )
    );
  }

  Widget buildText({required String text})=>
      Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  Widget buildAbout(String string) => Container(
    padding: EdgeInsets.fromLTRB(48, 10, 0, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        buildText(text: string),
      ],
    ),
  );

  Widget buildButton(User user) => ElevatedButton(
    style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        onPrimary: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        primary: Colors.white30
    ),
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfile(user: user))
      );
    },
    child: Text('Edit profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
  );

  Widget buildApp(Profile profile) => Scaffold(
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
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: secondaryColor,
          ),
          onPressed: () {
            // do something
          },
        ),
      ],
    ),
    body: ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Positioned(
                  top: 50,
                  right: 280,
                  child: buildImage(path: profile.user.avatar!.fileName),
                ),
              ]
              ),
              Column(children:[
                buildText(text: profile.numFriends.toString()),
                buildText(text: 'Friends')
              ],
              ),

              Column(children:[
                buildText(text: profile.numPosts.toString()),
                buildText(text: 'Posts')
              ])
            ],
          ),
        ),
        buildAbout(profile.user.description!),
        Center(child: buildButton(profile.user)),
      ],
    ),
  );
}
