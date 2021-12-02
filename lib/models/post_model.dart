import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/models/image_model.dart';
import 'package:fluttergram/models/video_model.dart';
import '../util/util.dart';
class Post {
  final String id;
  final User author;
  final String described, createdAt;
  final List<Image> images;
  final List<Video> videos;
  final List<User> like;
  final int countComments;

  Post({
    required this.id,
    required this.author,
    this.described = '',
    this.createdAt = '',
    this.images = const [],
    this.videos = const [],
    this.like = const [],
    this.countComments = 0
  });
  factory Post.fromJson(Map<String, dynamic> json){
    print('from json post');
    var a = Post(
      id: json['_id'] ?? '',
      author: User.fromJson(jsonConvert(json['author'])),
      described: json['described'] ?? '',
      createdAt: json['createdAt'] ?? '',
      images: List<Image>.generate(json['images'].length,(int index) => Image.fromJson(jsonConvert(json['images'][index]))),
      videos: List<Video>.generate(json['videos'].length,(int index) => Video.fromJson(jsonConvert(json['videos'][index]))),
      // Image.fromJson(json['avatar'] ?? {}),
      like: List<User>.generate(json['like'].length,(int index) => User.fromJson({})),
      countComments:json['countComments'] ?? 0 ,
    );
  print(a);
    return a;
  }

  @override
  String toString() {
    return 'Post{id: $id, author: $author, described: $described, createdAt: $createdAt, images: $images, videos: $videos, like: $like, countComments: $countComments}';
  }
}
