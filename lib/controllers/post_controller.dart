import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/models/image_model.dart';


List<User> Users = [
  User(id: '1', username: 'Emma Waston', phone: '0', password: 'a',
      avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
  User(id: '2', username: "Esther Howard",  phone: '0', password: 'a',
    avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
  User(id: '3', username: "Ralph Edwards",  phone: '0', password: 'a',
      avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
  User(id: '4', username: "Jacob Jones", phone: '0', password: 'a',
    avatar: Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")),
  User(id: '5', username: "Albert Flores", phone: '0', password: 'a',
    avatar:Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg"))];

Future<List<Post>> getPosts() async {
  return [
    Post(
        id: '1',
        author: Users[1],
        described: 'beautiful day',
        createdAt: '5m',
        images: [Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg"),
                    Image(id:'1', type: 'a', fileName:   "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")],
        like: [Users[0], Users[2]],
        countComments: 5),
    Post(
        id: '2',
        author: Users[0],
        described: 'I want to sleep',
        createdAt: '10m',
        images: [Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")],
        like: [Users[0], Users[2], Users[1]],
        countComments: 10),
    Post(
        id: '3',
        author: Users[3],
        described: 'perfect',
        createdAt: '15m',
        images: [Image(id:'1', type: 'a', fileName: "0a4efe47-fe2c-49c7-80b1-1b515595368a.jpeg")],
        like: [Users[0], Users[2], Users[1], Users[3]],
        countComments: 15)
  ];
}