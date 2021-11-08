import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:focused_menu/focused_menu.dart';


class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({Key? key}) : super(key: key);

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("New message", style: TextStyle(fontSize: postContentFontSize),)
    );
  }
}
