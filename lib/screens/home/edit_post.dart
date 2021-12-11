import 'package:flutter/material.dart';
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
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: Text('Edit Post'),
        )
    );
  }
}
