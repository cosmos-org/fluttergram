import 'package:fluttergram/models/image_model.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/user_model.dart';
import '../util/util.dart';

class Profile{
  User user;
  int numPosts;
  int numFriends;
  List<Post> listPost;

  Profile(this.user, this.numPosts, this.numFriends, this.listPost);

  @override
  String toString() {
    return 'Profile{user: $user, numPosts: $numPosts, numFriends: $numFriends, listPost: $listPost}';
  }
}