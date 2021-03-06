import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/post_controller.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/util/util.dart';
import '../../constants.dart';
import '../../default_screen.dart';

class EditPost extends StatefulWidget{
  final Post post;
  const EditPost({
    Key? key, required this.post,
    // required this.onPressed
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  @override
  Widget build(BuildContext context) {
    return buildApp(widget.post);
  }

  Widget buildApp(Post post) {
    TextEditingController describeController = TextEditingController();
    FocusNode describedNode = FocusNode();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: secondaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Center(
            child: Text('Edit Post'),
          ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    editPost(post, describeController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      textStyle: TextStyle(
                        color: secondaryColor,
                        fontSize: usernameFontSize,
                      )),
                  child: Text("Done"))
            ]
        ),
        body: Column(
          children: [
            ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Color(0xFFEEEEEE),
                    backgroundImage: getImageProviderNetWork(
                        post.author.avatar!.fileName),
                  ),
                ),
                title: Text(post.author.username),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: describeController,
                focusNode: describedNode,
                decoration: InputDecoration(
                    hintText: post.described),
              ),
            ),
            post.images.isNotEmpty
                ? Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: post.images.map((e) => ClipRRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getImageNetWork(e.fileName),
                      )
                    ],
                  ) ,
                )).toList(),
              ),
            )
                : const SizedBox.shrink(),

            ]
        )
        );
  }
}
