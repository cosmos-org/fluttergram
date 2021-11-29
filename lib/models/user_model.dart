import 'package:fluttergram/models/image_model.dart';

class User {
  String id;
  String phone;
  String username;
  Image? avatar;
  Image? cover_image;
  String? token;
  String password;

  User({
      required this.id,
      required this.phone,
      required this.username,
      required this.password,
      this.avatar,
      this.cover_image,
      this.token,
    }
  );

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['data']['id'],
      phone: json['data']['phonenumber'],
      username: json['data']['username'],
      password: '',
      // avatar: Image.fromJson(json['data']['avatar']),
      // cover_image: Image.fromJson(json['data']['cover_image']),
      token: json['token']
    );
  }

  factory User.getFriend(Map<String, dynamic> json){
    return User(
      id: json['_id'],
      phone: json['phonenumber'],
      username: json['username'],
      password: '',
      avatar: Image.fromJson(json['avatar']),
      cover_image: Image.fromJson(json['cover_image']),
      // token: json['token']
    );
  }

}
