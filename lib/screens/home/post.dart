import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/post_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/screens/home/post_container.dart';

class Posts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: getPosts(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator()
          );
        };
        if (snapshot.hasError) {
          return Text("Error");
        };
        List<Post> list = snapshot.data as List<Post>;
        // return PostContainer(post: list[0]);
        return Container(
            child: SingleChildScrollView(
            child: Wrap(
              spacing: 10, // set spacing here
              children: createPostList(list, 0),
            )
        )
        );
      },
    );
  }
}

List<Widget> createPostList(postList, currentScreen) {
  var ls = <PostSearched>[];
  postList.forEach((ele) {
    ls.add(new PostSearched(post: ele, currentScreen: currentScreen));
  });
  return ls;
}

class PostSearched extends StatelessWidget {
  final Post post;
  final int currentScreen;
  PostSearched({Key? key, required this.post,
                          required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return PostContainer(post: post, currentScreen: currentScreen);
  }
}