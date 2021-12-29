import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/home/post_controller.dart';
import 'package:fluttergram/util/util.dart';
import '../../constants.dart';
import 'package:fluttergram/models/comment_model.dart';


class EditComment extends StatefulWidget{
  Comment comment;
  int index;
  Function callBackComment;
  EditComment({
    Key? key,
    required this.callBackComment,
    required this.comment,
    required this.index
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {

  @override
  Widget build(BuildContext context) {
    return buildApp(widget.index, widget.comment,  widget.callBackComment);
  }

  Widget buildApp(int index, Comment comment, Function callBackComment) {
    TextEditingController describeController = TextEditingController();
    describeController.text = comment.content;
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
              child: Text('Edit Comment'),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    editComment(comment.id, describeController.text);
                    callBackComment(describeController.text, index);
                    Navigator.pop(context);
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
                        comment.author.avatar!.fileName),
                  ),
                ),
                title: Text(comment.author.username),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  controller: describeController,
                  focusNode: describedNode,
                  decoration: InputDecoration(
                      hintText: comment.content),
                ),
              ),
            ]
        )
    );
  }
}
