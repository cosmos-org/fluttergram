import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/models/image_model.dart';


List<User> Users = [
  User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
      avatar: Image(id:'1', type: 'a', filename: "assets/images/user.png")),
  User(id: '2', username: "Esther Howard",  phone: '0', password: 'a',
    avatar: Image(id:'1', type: 'a', filename: "assets/images/user_2.png")),
  User(id: '3', username: "Ralph Edwards",  phone: '0', password: 'a',
      avatar: Image(id:'1', type: 'a', filename: "assets/images/user_3.png")),
  User(id: '4', username: "Jacob Jones", phone: '0', password: 'a',
    avatar: Image(id:'1', type: 'a', filename: "assets/images/user_4.png")),
  User(id: '5', username: "Albert Flores", phone: '0', password: 'a',
    avatar:Image(id:'1', type: 'a', filename: "assets/images/user_5.png"))];

Future<List<Post>> getPosts() async {
  return [
    Post(author: Users[1],
        described: 'beautiful day',
        timeAgo: '5m',
        images: [Image(id:'1', type: 'a', filename: "assets/images/post1.jpg"),
                    Image(id:'1', type: 'a', filename:   "assets/images/post2.jpg")],
        like: [Users[0], Users[2]],
        countComments: 5),
    Post(author: Users[0],
        described: 'I want to sleep',
        timeAgo: '10m',
        images: [Image(id:'1', type: 'a', filename: "assets/images/post3.jpg")],
        like: [Users[0], Users[2], Users[1]],
        countComments: 10),
    Post(author: Users[3],
        described: 'perfect',
        timeAgo: '15m',
        images: [Image(id:'1', type: 'a', filename: "assets/images/post4.jpg")],
        like: [Users[0], Users[2], Users[1], Users[3]],
        countComments: 15)
  ];
}