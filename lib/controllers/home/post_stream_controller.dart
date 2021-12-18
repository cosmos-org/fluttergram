import 'package:fluttergram/constants.dart';
import '../../models/post_model.dart';
import 'dart:async';
import 'post_controller.dart';
class PostStreamModel{
  late Stream<List<Post>> stream;
  late bool hasMore;
  late bool _isLoading;
  late List<Post> _data;
  late StreamController<List<Post>> _controller;

  PostStreamModel() {
    _controller = StreamController<List<Post>>.broadcast();
    _data = <Post>[];

    _isLoading = false;
    stream = _controller.stream.map((List<Post> pstList) {
      return pstList;
    });
    hasMore = true;
    refresh();
  }
  Future<void> refresh() {
    return loadMore(clearCachedData: true, page : 0);
  }

  Future<void> loadMore({bool clearCachedData = false, int page = 0}) {
    if (clearCachedData) {
      // _data = <Message>[];
      _data = <Post>[];
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return getPostsByPage(page).then((List<Post> postList){
      _isLoading = false;

      _data.addAll(postList);

      hasMore = (postList.length == numberPostPerPage);

      _controller.add(_data);
    });

  }
}