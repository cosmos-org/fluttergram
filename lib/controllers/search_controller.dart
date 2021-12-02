import 'dart:convert';
import '../models/user_model.dart';
import '../models/image_model.dart';
import '../models/post_model.dart';
import 'package:fluttergram/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttergram/constants.dart';

final String searchUsersURL = hostname + '/api/v1/users/search';
final String searchPostsURL = hostname + '/api/v1/posts/search';

Future<List<User>> getSearchUserResult(token, keyword) async {
  return [];
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
  print(resp);

  if (resp['message'].toLowerCase().contains('success')) {


    var ls = <User>[];
    // for element
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
      ls.add(User.fromJson(element));
    };
    // );

    return ls;
    // return [
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    // ];
  }

  else return [];
}

Future<List<Post>> getSearchPostResult(token, keyword) async {
  print('In API search post call');
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
  print('post resp');
  print(resp);

  if (resp['message'].toLowerCase().contains('success')) {
    print('have data');
    print(resp['data'].runtimeType);
    print(resp['data'].length);
    print('time type');
    print(resp['data'][0]['createdAt'].runtimeType);
    var ls = <Post>[];
    // for element
    for (var element in resp['data'])
      // resp['data'].foreach((element)
        {
      ls.add(Post.fromJson(element));
    };
    // );
    print('length:');
    print(ls.length);
    print('ele 0');
    print(ls[0]);
    return ls;
    // return [
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    //   User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
    //       avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
    // ];
  }

  else return [];
}

