import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/post_controller.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/comment_model.dart';
import 'package:fluttergram/models/user_model.dart';
import '../../util/util.dart';
import 'package:fluttergram/constants.dart';

class PostView extends StatefulWidget {
  final Post post;
  final List<Comment> listComment;
  final User user;
  PostView({Key? key,
  required this.post, required this.listComment, required this.user}
  ) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostViewState(post: post, listComment: listComment, user: user);
}

class _PostViewState extends State<PostView> {

  final Post post;
  List<Comment> listComment;
  User user;

  _PostViewState({
    required this.post, required this.listComment, required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Page(user, listComment, post);
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

class Page extends StatefulWidget{
  final User user;
  final List<Comment> listComment;
  final Post post;

  Page(this.user, this.listComment, this.post);


  @override
  State<StatefulWidget> createState() => _PageState(post, listComment, user);
}

class _PageState extends State<Page>{
  Post post;
  List<Comment> listComment;
  User user;
  ScrollController controller = new ScrollController();


  _PageState(this.post, this.listComment, this.user);

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
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
                child: ListView.builder(
              itemCount: listComment.length,
              itemBuilder: (context, index) {
                final item = listComment[index];
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
                        User userComment = snapshot.data!;
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Color(0xFFEEEEEE),
                              backgroundImage: getImageProviderNetWork(
                                  userComment.avatar!.fileName),
                            ),
                          ),

                          trailing: Text(item.createdAt),
                          title: Text(item.author.username),
                          subtitle: Text(item.content),
                          onTap: () {},
                        );
                      }
                    }
                );}
                )


          ),
        ],
      ),
      bottomNavigationBar: Container(
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
                            backgroundImage: getImageProviderNetWork(user.avatar!.fileName),
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
                            String createdAt = "Just now";
                            Comment newComment = Comment(id: "", author: user, postId: post.id, content: commentController.text, createdAt: createdAt);
                            controller.jumpTo((listComment.length + 1)*100.0);
                            setState(() {
                              this.listComment.add(newComment);
                            });
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
      )
    );
  }
}
