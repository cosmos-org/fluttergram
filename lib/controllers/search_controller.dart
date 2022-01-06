import 'dart:convert';
import '../models/user_model.dart';
import '../models/image_model.dart';
import '../models/post_model.dart';
import 'package:fluttergram/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttergram/constants.dart';
import '../util/util.dart';
final String searchUsersURL = hostname + '/api/v1/users/search';
final String searchPostsURL = hostname + '/api/v1/posts/search';

Future<List<User>> getSearchUserResultAPI( keyword) async {
  String token = await getToken();
  final response = await http
      .post(Uri.parse(searchUsersURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
    body: jsonEncode(<String, String>{
      'keyword': keyword,
    }),
  );
  var resp = jsonDecode(response.body);

  if (checkMessageResponse(resp['message'])) {

    var ls = <User>[];
    // for element
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
      ls.add(User.fromJson(element));
    };
    // );

    return ls;
  }

  else return [];
}

Future<List<Post>> getSearchPostResultAPI( keyword) async {
  String token = await getToken();
  final response = await http
      .post(Uri.parse(searchPostsURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'bearer ' + token,
    },
    body: jsonEncode(<String, String>{
      'keyword': keyword,
    }),
  );
  var resp = jsonDecode(response.body);

  if (checkMessageResponse(resp['message'])) {
    var ls = <Post>[];
    // for element
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
       ls.add(Post.fromJson(element));
    };
    // );
    return ls;
  }

  else return [];
}

