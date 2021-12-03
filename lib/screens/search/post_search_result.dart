import 'package:fluttergram/screens/home/post.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/screens/home/post_container.dart';

const String getFileUrl = hostname+ '/files/';

class PostSearchedList extends StatelessWidget {
  final List<Post> posts;


  PostSearchedList({Key? key, required this.posts});

  @override
  Widget build(BuildContext context) {
    print("Post searched length: ");
    print(posts.length);
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
      color: Colors.white,
      child: SingleChildScrollView(
          child: Wrap(
            spacing: 10, // set spacing here
            children: createPostList(posts),
          )
      ),
      // child: SingleChildScrollView(
      //     child: ListView.separated(
      //       shrinkWrap: true,
      //       separatorBuilder: (BuildContext context, int index) {
      //         return SizedBox(
      //             height: 5,
      //             child: DecoratedBox(
      //               decoration: BoxDecoration(
      //                 color: Colors.black26,
      //               ),
      //             )
      //         );
      //       },
      //       itemCount: posts.length,
      //       itemBuilder: (_, i) => PostSearched(post: posts[i]),
      //     )
      // ),
    );
  }
}
List<Widget> createPostList(postList) {
  var ls = <PostSearched>[];
  postList.forEach((ele) {
    ls.add(new PostSearched(post: ele));
  });

  return ls;
}

class PostSearched extends StatelessWidget {
  final Post post;
  PostSearched({Key? key, required this.post});

  @override
  Widget build(BuildContext context) {
    return PostContainer(post: post);
  }
}
