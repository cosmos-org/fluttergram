import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';


class SearchMessagesScreen extends StatefulWidget {
  const SearchMessagesScreen({Key? key}) : super(key: key);

  @override
  _SearchMessagesScreenState createState() => _SearchMessagesScreenState();
}

class _SearchMessagesScreenState extends State<SearchMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Search message", style: TextStyle(fontSize: postContentFontSize),)
    );
  }
}
