import 'dart:convert';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/comment_model.dart';
import 'package:fluttergram/util/util.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> getPosts() async {
  String token = await getToken();

  final response = await http.get(
      Uri.parse(hostname + postGetListEndpoint + '?page=0'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
  var resp = jsonDecode(response.body);

  var ls = <Post>[];
  for (var element in resp['data']) {
    ls.add(Post.fromJson(element));
  }
  return ls;
}

Future<bool> isLiked(Post post) async {
  String id = await getCurrentUserId();
  for (var userId in post.like) {
    if (userId == id) {
      return true;
    }
  }
  return false;
}

Future<void> likePost(Post post) async {
  String token = await getToken();
  String url = hostname + postLikeEndpoint + post.id;
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
}

Future<void> reportPost(Post post) async{
  String token = await getToken();
  String url = hostname + postReportEndpoint + post.id;
  String body = '{"subject": "1", "details": ""}';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: body);
}

Future<void> deletePost(Post post) async{
  String token = await getToken();
  String url = hostname + postDeleteEndpoint + post.id;
  final response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
}


Future<void> createComment(Post post, String content) async{
  String token = await getToken();
  String url = hostname + postCreateCommentEndpoint + post.id;
  String body = '{"content": "$content"}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: body);
}

Future<void> editPost(Post post, String described) async{
  String token = await getToken();
  String url = hostname + postEditEndpoint + post.id;
  String images = post.images.toString();
  String videos = post.videos.toString();
  String body = '{"described": "$described", "images": "$images", "videos": "$videos"}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: body);
}

Future<List<Comment>> getComment(Post post) async{
  String token = await getToken();
  String url = hostname + postGetCommentEndpoint + post.id;
  final response = await http.get(Uri.parse(url), headers: <String, String>{
    'Content-Type': 'application/json',
    'authorization': 'bearer ' + token,
  });
  dynamic respBody = jsonDecode(response.body);
  var ls = <Comment>[];
  for (var element in respBody['data']) {
    ls.add(Comment.fromJson(element));
  }
  return ls;
}

Future<int> createPost(
    String description, List<String> images, List<String> videos) async {
  String token = await getToken();
  String url = hostname + postCreateEndpoint;
  String images_value = "[]",
      videos_value = "[]";
  if (images.isNotEmpty) {
    images_value = '[';
    for (int i = 0; i < images.length; i++) {
      String b64 = images[i];
      images_value += '"data:image/jpeg;base64,$b64"';
      if (i != images.length - 1) {
        images_value += ', ';
      } else
        images_value += ']';
    }
  }

  if (videos.isNotEmpty) {
    videos_value = '[';
    for (int i = 0; i < videos.length; i++) {
      String b64 = videos[i];
      videos_value += '"data:video/mp4;base64,$b64"';
      if (i != videos.length - 1) {
        videos_value += ', ';
      } else
        videos_value += ']';
    }
  }
  String body =
      '{"described": "$description", "images": $images_value, "videos": $videos_value}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: body);

  dynamic respBody = jsonDecode(response.body);
  int code = respBody["code"];
  return code;
}