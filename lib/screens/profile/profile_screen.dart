import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergram/models/profile.dart';
import 'package:fluttergram/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Profile('https://i.pinimg.com/736x/5b/19/fb/5b19fb0aaa68f8b856a093b64431631f.jpg',
        'Duong Dao', 'Duongdd', 23, 10, 'A hust boiz');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Text(user.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.black,
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
                      child: buildImage(path: user.imagePath),
                    ),
                    buildText(text: '@' + user.nickName)
                  ]
                  ),
                  Column(children:[
                    buildText(text: user.numberFriends.toString()),
                    buildText(text: 'Friends')
                  ],
                  ),

                  Column(children:[
                    buildText(text: user.numberPosts.toString()),
                    buildText(text: 'Posts')
                  ])
                ],
              ),
            ),
            buildAbout(user),
            Center(child: buildButton('Edit profile'),),
            Container(
              padding: EdgeInsets.fromLTRB(48, 10, 0, 20),
              child: buildText(text: 'Create new post'),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(48, 10, 48, 60),
              child: TextField(
                  decoration: new InputDecoration(labelText: "What do you think?", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.blue)), filled: true,
                    contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),),
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.singleLineFormatter]
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      children:[
                        Positioned(
                          top: 50,
                          right: 280,
                          child: buildButton('Create post'),
                        )
                      ]
                  ),
                  Column(
                      children:[
                        Positioned(
                          top: 50,
                          right: 280,
                          child: buildButton('Add media'),
                        )
                      ]
                  )
                ])
          ],
        ),
    );
  }

  Widget buildImage({required String path}) {
    final image = NetworkImage(path);
    return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
          ),
        ));
  }

  Widget buildText({required String text})=>
      Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

  Widget buildAbout(Profile user) => Container(
    padding: EdgeInsets.fromLTRB(48, 10, 0, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        buildText(text: user.about),
      ],
    ),
  );

  Widget buildButton(String text) => ElevatedButton(
    style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        onPrimary: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        primary: Colors.white30
    ),
    onPressed: () { },
    child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
  );
}
