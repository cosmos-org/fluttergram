import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/home/post_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/comment_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import '../../util/util.dart';
import 'package:fluttergram/constants.dart';

import 'edit_comment.dart';

class PostView extends StatefulWidget {
  final Post post;
  final List<Comment> listComment;
  final User user;
  Function callBackNumComments;
  PostView(
      {Key? key,
      required this.post,
      required this.listComment,
      required this.user,
      required this.callBackNumComments})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _PostViewState(post: post, listComment: listComment, user: user, callBackNumComments: callBackNumComments);
}

class _PostViewState extends State<PostView> {
  final Post post;
  List<Comment> listComment;
  User user;
  Function callBackNumComments;

  _PostViewState(
      {required this.post, required this.listComment, required this.user,
      required this.callBackNumComments});

  @override
  Widget build(BuildContext context) {
    return Page(user, listComment, post, callBackNumComments);
  }
}

class _Post extends StatelessWidget {
  final Post post;

  _Post({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        child: CircleAvatar(
          radius: 20.0,
          backgroundColor: Color(0xFFEEEEEE),
          backgroundImage:
              getImageProviderNetWork(post.author.avatar!.fileName),
        ),
      ),
      title: Text(post.author.username),
      subtitle: Text(post.described),
      onTap: () {},
    );
  }
}

class Page extends StatefulWidget {
  final User user;
  final List<Comment> listComment;
  final Post post;
  Function callBackNumComments;
  Page(this.user, this.listComment, this.post, this.callBackNumComments);

  @override
  State<StatefulWidget> createState() => _PageState(post, listComment, user,callBackNumComments);
}

class _PageState extends State<Page> {
  Post post;
  List<Comment> listComment;
  User user;
  ScrollController controller = new ScrollController();
  Function callBackNumComments;
  List<String> comments = [];
  _PageState(this.post, this.listComment, this.user, this.callBackNumComments);
  void callBackComment(String text, int index){
    setState((){
      comments[index] = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    for(var c in listComment){
      comments.add(c.content);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text('Comments'),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: _Post(post: post),
          ),
          Divider(color: Colors.grey),
          Container(
            child: Text("You can only see your friends's comments"),
          //   child: Card(
          //       color: ,
          //       margin: EdgeInsets.only(
          //           left: 4, right: 4, bottom: 8),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     child: Text("You can only see your friends's comments",
          //     : Colors.grey)
          // ),
          ),
          Expanded(
              child: ListView.builder(
                  controller: controller,
                  itemCount: listComment.length,
                  itemBuilder: (context, index) => FocusedMenuHolder(
                      blurSize: 0.3,
                      blurBackgroundColor: secondaryColor,
                      menuWidth: 200,
                      menuItems:
                        user.id == listComment[index].author.id
                          ? <FocusedMenuItem>[
                          FocusedMenuItem(
                              title: Text("Edit", style: TextStyle(color: errorColor)),
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (contex) =>
                                    EditComment(comment: listComment[index], callBackComment: callBackComment, index: index)
                                ));
                              }
                              ),
                          FocusedMenuItem(
                              title: Text("Delete"), onPressed: () {
                              callBackNumComments(-1);
                              deleteComment(listComment[index].id);
                              setState((){
                                this.listComment.removeAt(index);
                                comments.removeAt(index);
                                controller
                                    .jumpTo((listComment.length - 1) * 100.0);
                              });
                          }),
                          ]
                          : user.id == post.author.id
                            ?  <FocusedMenuItem>[
                                  FocusedMenuItem(
                                      title: Text("Delete"), onPressed: () {
                                    callBackNumComments(-1);
                                    deleteComment(listComment[index].id);
                                    setState((){
                                      this.listComment.removeAt(index);
                                      comments.removeAt(index);
                                      controller
                                          .jumpTo((listComment.length - 1) * 100.0);
                                    });
                                  }),
                                ]
                            : <FocusedMenuItem>[],
                      onPressed: () {},
                      child: ListTile(
                      leading: CircleAvatar(
                        radius: 20.0,
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Color(0xFFEEEEEE),
                          backgroundImage: getImageProviderNetWork(
                              listComment[index].author.avatar!.fileName),
                        ),
                      ),
                      trailing: Text(listComment[index].createdAt),
                      title: Text(listComment[index].author.username),
                      subtitle: Text(comments[index]),
                      onTap: () {},
                    ))
                  )),
          Container(
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    blurRadius: 6.0,
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          contentPadding: EdgeInsets.all(20.0),
                          hintText: 'Add a comment',
                          prefixIcon: Container(
                            margin: EdgeInsets.all(4.0),
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 20.0,
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Color(0xFFEEEEEE),
                                backgroundImage: getImageProviderNetWork(
                                    user.avatar!.fileName),
                              ),
                            ),
                          ),
                          suffixIcon: Container(
                            margin: EdgeInsets.only(right: 4.0),
                            width: 70.0,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: primaryColor,
                                  primary: primaryColor),
                              onPressed: () {
                                createComment(post, commentController.text);
                                String createdAt = "Just now";
                                Comment newComment = Comment(
                                    id: "",
                                    author: user,
                                    postId: post.id,
                                    content: commentController.text,
                                    createdAt: createdAt);
                                callBackNumComments(1);
                                setState(() {
                                  this.listComment.add(newComment);
                                  comments.add(commentController.text);
                                  controller
                                      .jumpTo((listComment.length + 1) * 100.0);
                                });
                              },
                              child: Icon(
                                Icons.send,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),
                          )))))
        ],
      ),
    );
  }
}
