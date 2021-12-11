import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/post_controller.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/comment_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:http/http.dart';
import '../../util/util.dart';
import 'package:fluttergram/constants.dart';

class PostView extends StatefulWidget {
  final Post post;
  const PostView({Key? key,
  required this.post}
  ) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostViewState(post: post);
}

class _PostViewState extends State<PostView> {

  final Post post;

  _PostViewState({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
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
            Divider(
                color: Colors.grey
            ),
            Expanded(
                child: _ListComment(post: post)
            )
          ],
        ),
        bottomNavigationBar: _navBar(post: post)
    );
  }
}


class _ListComment extends StatelessWidget {
  final Post post;

  _ListComment({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
        future: getComment(post),
        builder: (BuildContext context, AsyncSnapshot<List<Comment>> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            List<Comment> items = snapshot.data!;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  String userId = item.author.id;
                  return FutureBuilder<User>(
                      future: getAnotherUser(userId),
                      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                        if (!snapshot.hasData) {
                          // while data is loading:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else {
                          User user = snapshot.data!;
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 20.0,
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Color(0xFFEEEEEE),
                                backgroundImage: getImageProviderNetWork(
                                    user.avatar!.fileName),
                              ),
                            ),

                            trailing: Text(item.createdAt),
                            title: Text(item.author.username),
                            subtitle: Text(item.content),
                            onTap: () {},
                          );
                        }
                      }
                      );
                }

            );
          }
        });
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
          backgroundImage: getImageProviderNetWork(
              post.author.avatar!.fileName),
        ),
      ),
      title: Text(post.author.username),
      subtitle: Text(post.described),
      onTap: () {},
    );
  }
}


class _navBar extends StatelessWidget {
  final Post post;

  _navBar({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return FutureBuilder<User>(
        future: getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            User currentUser = snapshot.data!;
            return Container(
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
                                  backgroundImage: getImageProviderNetWork(currentUser.avatar!.fileName),
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
                                    primary: primaryColor
                                ),
                                onPressed: (){
                                  createComment(post, commentController.text);
                                },
                                child: Icon(
                                  Icons.send,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        )
                    )
                )
            );
          }
        }
        );
        }
  }