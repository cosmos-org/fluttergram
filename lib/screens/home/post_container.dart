
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/comment_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/controllers/post_controller.dart';
import 'package:fluttergram/screens/home/post_view_screen.dart';
import '../../constants.dart';
import '../../util/util.dart';
class PostContainer extends StatelessWidget {
  final Post post;
  const PostContainer({
    Key? key,
    required this.post}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
          children:[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PostHeader(post: post),
                    const SizedBox(height: 4.0),
                    Text(post.described),
                    post.images.isNotEmpty
                          ? const SizedBox.shrink()
                        : const SizedBox(height: 6.0),
                  ],
                )
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: PostStats(post: post),
            ),
          ]
      ),
    );
  }
}

class _moreOption extends StatelessWidget {
  final Post post;

  const _moreOption({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getCurrentUser(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          };
          if (snapshot.hasError) {
            return Text("Error");
          };
          User currentUser =  snapshot.data as User;
          List<String> actions = [];
          if (post.author.id == currentUser.id) {
            actions = <String>[
              'Edit',
              'Delete'
            ];
          }
          else
            actions = <String>['Report'];
          // print(post.author.id);
          // print('current id ' + currentUser.id);
          // print(actions[0]);

          onAction(String action) async {
            switch (action) {
              case 'Edit':
                break;
              case 'Delete':
                break;
              case 'Report':
                break;
            }
            // print(action);
          }

          return PopupMenuButton(
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
        }
    );
  }
}

class _PostHeader extends StatelessWidget {
  final Post post;

  const _PostHeader({
    Key? key,
    required this.post,
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
            backgroundImage: getImageProviderNetWork(post.author.avatar!.fileName),
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
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () => _moreOption(post: post),
        ),
      ],
    );
  }
}

class PostStats extends StatefulWidget {
  final Post post;
  const PostStats({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _PostStats createState() => _PostStats(post: post);
}

class _PostStats extends State<PostStats> {
  final Post post;

  _PostStats({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: isLiked(post),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            bool isLiked = snapshot.data!;
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
                        '${post.like.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Text(
                      '${post.countComments} Comments',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                isLiked = !isLiked;
                              });
                              likePost(post);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              height: 25.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_rounded,
                                    color: isLiked ? likeColor : unlikeColor,
                                    size: 20.0,
                                ),
                                const SizedBox(width: 4.0),
                                Text("Like"),
                                ],
                              ),
                            ),
                            ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () async {
                              List<Comment> listComment = await getComment(post);
                              User user = await getCurrentUser();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostView(post: post, listComment: listComment, user: user)),
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

                    ]
                )
              ],
            );
          }
        }
    );
  }
}