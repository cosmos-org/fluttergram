import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/home/post_controller.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/screens/home/post_container.dart';
import '../../controllers/home/post_stream_controller.dart';
class Posts extends StatefulWidget {
  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late PostStreamModel _postStreamModel;

  ScrollController _scrollController =new ScrollController(
   initialScrollOffset: 0,
   keepScrollOffset: true,
  );


  late int currentPage;
  @override
  void initState() {
    currentPage = 0;
    _postStreamModel = PostStreamModel();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        this.currentPage = this.currentPage + 1;
        _postStreamModel.loadMore(page: this.currentPage);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _postStreamModel.stream,
        builder:(BuildContext _context,AsyncSnapshot _snapshot){
          if (_snapshot.hasError) {
            return Center(
                child: Text("Error")
            );
          };
          if (!_snapshot.hasData){

            return Center(child: CircularProgressIndicator());
          } else{
            // loadMore(_snapshot.data);
            List<Post> list = _snapshot.data as List<Post>;
            print('post list length '+ list.length.toString());
            return RefreshIndicator(
                onRefresh: _postStreamModel.refresh,
                child:SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),

                    controller: _scrollController,
                    child: Wrap(
                      spacing: 10, // set spacing here
                      children:  _postStreamModel.hasMore ? createPostListAndLoading(list, 0) : createPostList(list, 0),
                    )
                ),
            );
          }
        }
    );
    //   FutureBuilder<List<Post>>(
    //   future: getPosts(),
    //   builder: (ctx, snapshot) {
    //     if (snapshot.connectionState != ConnectionState.done) {
    //       return Center(
    //           child: CircularProgressIndicator()
    //       );
    //     };
    //     if (snapshot.hasError) {
    //       return Text("Error");
    //     };
    //     List<Post> list = snapshot.data as List<Post>;
    //     // return PostContainer(post: list[0]);
    //     return Container(
    //         child: SingleChildScrollView(
    //         child: Wrap(
    //           spacing: 10, // set spacing here
    //           children: createPostList(list, 0),
    //         )
    //     )
    //     );
    //   },
    // );
  }
}
List<Widget> createPostListAndLoading(postList, currentScreen) {
  var ls = <Widget>[];
  postList.forEach((ele) {
    ls.add(new PostSearched(post: ele, currentScreen: currentScreen));
  });
  ls.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(child: CircularProgressIndicator()),
      )
  );
  return ls;
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