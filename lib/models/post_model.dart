import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/models/image_model.dart';


class Post {
  final User author;
  final String described, timeAgo;
  final List<Image> images;
  final List<String> videos;
  final List<User> like;
  final int countComments;

  Post({
    required this.author,
    this.described = '',
    this.timeAgo = '',
    this.images = const [],
    this.videos = const [],
    this.like = const [],
    this.countComments = 0
  });
}
