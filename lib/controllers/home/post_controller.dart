import 'dart:convert';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/comment_model.dart';
import 'package:fluttergram/util/util.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> getPosts() async {
  String token = await getToken();
  String id = await getCurrentUserId();

  final response = await http.get(
      Uri.parse(hostname + postGetListEndpoint + '?page=0'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
  var resp = jsonDecode(response.body);

  var ls = <Post>[];
  for (var element in resp['data']) {
    Post p = Post.fromJson(element);
    p.isLikedBy = false;
    for(var userId in p.like){
      if (userId == id){
        p.isLikedBy = true;
      }
    }
    ls.add(p);
  }
  return ls;
}

Future<List<Post>> getPostsByPage(int page) async {
  String token = await getToken();
  String id = await getCurrentUserId();

  final response = await http.get(
      Uri.parse(hostname + postGetListEndpoint + '?page='+ page.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
  var resp = jsonDecode(response.body);

  var ls = <Post>[];
  for (var element in resp['data']) {
    Post p = Post.fromJson(element);
    p.isLikedBy = false;
    for(var userId in p.like){
      if (userId == id){
        p.isLikedBy = true;
      }
    }
    ls.add(p);
  }
  return ls;
}


Future<List<Post>> getPostsByUserId(String userId) async {
  String token = await getToken();
  final response = await http.get(
      Uri.parse(hostname + postGetListEndpoint + '?page=0' + '&userId=' + userId),
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

Future<Post> getPostById(String postId) async {
  String token = await getToken();

  final response = await http.get(
      Uri.parse(hostname + postGetByIDEndpoint + postId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
  var resp = jsonDecode(response.body);

  Post p = Post.fromJson(resp['data']);

  return p;
}

Future<List<Post>> getMyPosts() async {
  String token = await getToken();
  String myId = await getCurrentUserId();
  final response = await http.get(
      Uri.parse(hostname + postGetListEndpoint + '?page=0' + '&userId=' + myId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
  var resp = jsonDecode(response.body);
  var ls = <Post>[];
  for (var element in resp['data']) {
    Post p = Post.fromJson(element);
    p.isLikedBy = false;
    for(var userId in p.like){
      if (userId == myId){
        p.isLikedBy = true;
      }
    }
    ls.add(p);
  }
  return ls;
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

Future<bool> reportPost(Post post,String subject,String detail) async{
  String token = await getToken();
  String url = hostname + postReportEndpoint + post.id;
  String body = '{"subject": "${subject}", "details": "${detail}"}';
  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: body);
  int statusCode = response.statusCode;
  dynamic respBody = jsonDecode(response.body);
  if (statusCode < 300) {
    if (checkMessageResponse(respBody['message'])) {return true;}
    else return false;
  } else {
    return false;
  }
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
  List<String> images = [];
  List<String> videos =[];
  for(var image in post.images){
      // String tmp = await encodeImage(image.fileName);
      // print(tmp);
      // images.add(tmp);
  }
  for(var video in post.videos){
    // videos.add(jsonEncode(video));
  }
  String body = '{"described": "$described", "images": "$images", "videos": "$videos"}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      },
      body: body);
  dynamic respBody = jsonDecode(response.body);

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