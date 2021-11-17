import '../models/user_model.dart';

Future<List<User>> getUsers() async {
  return [
    User(userId: '1', name: "Jenny Wilson"),
    User(userId: '2', name: "Esther Howard"),
    User(userId: '3', name: "Ralph Edwards"),
    User(userId: '4', name: "Jacob Jones"),
    User(userId: '5', name: "Albert Flores"),
  ];
}
