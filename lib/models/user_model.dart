import 'package:fluttergram/models/image_model.dart';
import '../util/util.dart';
class User {
  String id;
  String phone;
  String username;
  Image? avatar;
  Image? cover_image;
  String password;
  String? birthday;
  String? description;
  String? address;
  String? city;
  String? country;
  String? link;
  String? gender;
  List<String>? blocked_inbox;
  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      '_id': id,
      'username': username,
      'avatar': avatar!.toMap(),
      'cover_image': cover_image!.toMap(),
      'password': password,
      'birthday': birthday,
      'description': description,
      'address': address,
      'city': city,
      'country': country,
      'link': link,
      'gender': gender,
      'blocked_inbox': blocked_inbox
    };
  }
  User({
    required this.id,
    required this.phone,
    required this.username,
    required this.password,
    this.avatar,
    this.cover_image,
    this.birthday,
    this.address,
    this.description,
    this.city,
    this.country,
    this.link,
    this.gender,
    this.blocked_inbox,
  }
      );

  factory User.fromJson(Map<String, dynamic> json){
    var a = User(
      id: json['_id'] ?? '',
      phone: json['phonenumber'] ?? '',
      username: json['username'] ?? '',
      password: '',
      avatar: Image.fromJson(jsonConvert(json['avatar'] ?? {})),
      cover_image: Image.fromJson(jsonConvert(json['cover_image'] ?? {})) ,
      birthday: json['birthday'] ?? 'Unknown',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      link: json['link'] ?? '',
      gender: json['gender'] ?? 'Secret',
      blocked_inbox: [''],
    );

    return a;
  }

  @override
  String toString() {
    return 'User{id: $id, phone: $phone, username: $username, avatar: $avatar, cover_image: $cover_image,  password: $password, birthday: $birthday, description: $description, address: $address, city: $city, country: $country, link: $link, gender: $gender, blocked_inbox: $blocked_inbox}';
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
  factory User.fromJsonLogIn(Map<String, dynamic> json){

    var a = User(
      id: json['data']['_id'] ?? '',
      phone: json['data']['phonenumber'] ?? '',
      username: json['data']['username'] ?? '',
      password: '',
      avatar: Image.fromJson(jsonConvert(json['avatar'])),
      cover_image: Image.fromJson(jsonConvert(json['cover_image'])) ,

      birthday: json['birthday'] ?? 'Unknown',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      link: json['link'] ?? '',
      gender: json['gender'] ?? 'Secret',
      blocked_inbox: [''],
    );
    return a;
  }
}
