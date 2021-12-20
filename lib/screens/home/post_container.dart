import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/comment_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttergram/controllers/home/post_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/home/post_view_screen.dart';
import 'package:fluttergram/screens/home/video.dart';
import 'package:video_player/video_player.dart';
import '../../constants.dart';
import '../../default_screen.dart';
import '../../util/util.dart';
import 'edit_post.dart';



class PostContainer extends StatefulWidget {
  final Post post;
  final int currentScreen;
  PostContainer({Key? key, required this.post, required this.currentScreen})
      : super(key: key);

  @override
  _PostContainer createState() => _PostContainer(post, currentScreen, post.described);
}

class _PostContainer extends State<PostContainer> {
  Post post;
  int currentScreen;
  String numLikes = '';
  String numComments = '';
  String described;

  void callBackDescribed(String text){
    setState((){
      described = text;
    });
  }

  _PostContainer(this.post, this.currentScreen, this.described);

  @override
  Widget build(BuildContext context) {
    numLikes = post.like.length.toString();
    numComments = post.countComments.toString();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PostHeader(post: post, currentScreen: currentScreen,callBackDescribed: callBackDescribed),
                const SizedBox(height: 4.0),
                Text(described),
                post.images.isNotEmpty
                    ? const SizedBox.shrink()
                    : const SizedBox(height: 6.0),
              ],
            )),
        post.images.isNotEmpty
            ? Center(
                child: CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: post.images
                      .map((e) => ClipRRect(
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getImageNetWork(e.fileName),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              )
            // : const SizedBox.shrink(),
        : Padding(
            padding: const EdgeInsets.all(12.0),
            child:  ChewieListItem(
                      videoPlayerController: VideoPlayerController.network(
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                  ), looping: true,
            )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: PostStats(post: post, numLikes: numLikes, numComments: numComments)
        ),
      ]),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;
  final int currentScreen;
  Function callBackDescribed;

  _PostHeader({
    Key? key,
    required this.post,
    required this.currentScreen,
    required this.callBackDescribed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.0,
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                getImageProviderNetWork(post.author.avatar!.fileName),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author.username,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${post.createdAt} • ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  )
                ],
              ),
            ],
          ),
        ),
        FutureBuilder<String>(
            future: getCurrentUserId(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              ;
              if (snapshot.hasError) {
                return Text("Error");
              }
              ;
              String currentUserId = snapshot.data as String;
              List<String> actions = [];
              if (post.author.id == currentUserId) {
                actions = <String>['Edit', 'Delete'];
              } else
                actions = <String>['Report'];

              onAction(String action) {
                switch (action) {
                  case 'Edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPost(post: post, currentScreen: currentScreen,callBackDescribed: callBackDescribed)),
                    );
                    break;
                  case 'Delete':
                    showDeleteAlertDialog(context, post, currentScreen);
                    break;
                  case 'Report':
                    showReportAlertDialog(context, post);
                    break;
                }
              }

              return PopupMenuButton(
                icon: Icon(Icons.more_horiz),
                padding: const EdgeInsets.all(1.0),
                onSelected: onAction,
                itemBuilder: (BuildContext context) {
                  return actions.map((String action) {
                    return PopupMenuItem(
                      value: action,
                      child: Text(action),
                    );
                  }).toList();
                },
              );
            }),
      ],
    );
  }
}

class PostStats extends StatefulWidget {
  final Post post;
  String numLikes;
  String numComments;

  PostStats({
    Key? key,
    required this.post,
    required this.numLikes,
    required this.numComments,
  }) : super(key: key);

  @override
  _PostStats createState() => _PostStats(post: post, numLikes: numLikes, numComments: numComments,);
}

class _PostStats extends State<PostStats> {
  final Post post;
  String numLikes;
  String numComments;
  _PostStats({
    required this.post,
    required this.numLikes,
    required this.numComments,
  });

  void callBackNumLikes(int tmp){
    setState(() {
      var num = int.parse(numLikes);
      numLikes = (num + tmp).toString();
    });
  }
  void callBackNumComments(){
    setState((){
      var num = int.parse(numComments);
      numComments = (num + 1).toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up,
                      size: 12.0,
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        numLikes,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Text(
                      '${numComments} Comments',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(children: [
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          height: 25.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up_alt_rounded,
                                color: post.isLikedBy ? likeColor : unlikeColor,
                                size: 20.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text("Like"),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            post.isLikedBy = !post.isLikedBy;
                          });
                          likePost(post);
                          if (post.isLikedBy){
                            callBackNumLikes(1);
                          }
                          else{
                            callBackNumLikes(-1);
                          };

                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          List<Comment> listComment = await getComment(post);
                          for (var cm in listComment){
                            var userId = cm.author.id;
                            cm.author = await getAnotherUser(userId);
                          };
                          User user = await getCurrentUser();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostView(
                                    post: post,
                                    listComment: listComment,
                                    user: user,
                                    callBackNumComments: callBackNumComments)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          height: 25.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mode_comment_outlined,
                                size: 20.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text('Comment'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
              ],
            );
        //   }
        // });
  }
}

showDeleteAlertDialog(BuildContext context, Post post, int currentScreen) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      deletePost(post);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DefaultScreen(currentScreen: currentScreen)),
          ModalRoute.withName('/'));    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Post"),
    content: Text("Are you sure to delete this post?"),
    actions: [
      cancelButton,
      continueButton,
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

showReportAlertDialog(BuildContext context, Post post) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        reportPost(post);
        Navigator.of(context).pop();
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Report Post"),
    content: Text("Are you sure to report this post?"),
    actions: [
      cancelButton,
      continueButton,
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
