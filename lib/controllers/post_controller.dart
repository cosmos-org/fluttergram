import 'dart:convert';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/util/util.dart';
import 'package:http/http.dart';

Future<List<Post>> getPosts() async {
  String token = await getToken();
  final qParams = {
    'page': 0,
  };
  Response response = await get(Uri.https(hostname, postGetListEndpoint, qParams),
      headers: <String, String>{
    'Content-Type': 'application/json',
        'authorization': 'bearer ' + token,
      });
  var resp = jsonDecode(response.body);
  print(resp);

  var ls = <Post>[];
  for (var element in resp['data']) {
    ls.add(Post.fromJson(element));
  }
  return ls;
}


Future<bool> isLiked(Post post) async {
  String id = getCurrentUserId() as String;
  for (var user in post.like){
    if (user.id == id) {
      return true;
    }
  }
  return false;
}