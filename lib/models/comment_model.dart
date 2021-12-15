import 'package:fluttergram/util/util.dart';

import '../models/user_model.dart';
class Comment {
  String id, postId, content, commentAnswered, createdAt;
  User author;
  Comment({
    required this.id,
    required this.author,
    required this.postId,
    this.commentAnswered = '',
    this.content = '',
    this.createdAt = ''
  });

  factory Comment.fromJson(Map<String, dynamic> json){
    var a = Comment(
      id: json['_id'] ?? '',
      author: User.fromJson(jsonConvert(json['user'])),
      content: json['content'] ?? '',
      createdAt: timeAgo(json['createdAt']),
      postId: json['post'] ?? '',
      commentAnswered: '',
    );
    return a;
  }


}
