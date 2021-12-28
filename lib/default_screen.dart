import 'package:flutter/material.dart';
import 'package:fluttergram/util/util.dart';
import 'screens/home/home_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/conversations/conversation_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'constants.dart';

class DefaultScreen extends StatefulWidget {
  int currentScreen;
  DefaultScreen({Key? key, required this.currentScreen}) : super(key: key);

  @override
  _DefaultScreenState createState() => _DefaultScreenState(currentScreen);
}

class _DefaultScreenState extends State<DefaultScreen> {
  @override
  void initState() {
    saveDefaultScreenRef(this);
  }
  int _currentScreen = 0;
  final screens = [
    HomeScreen(),
    SearchScreen(),
    ConversationScreen(),
    ProfileScreen(),
  ];
  void callback (int screen){
    setState((){
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: _currentScreen,
      ),
      bottomNavigationBar: buildBottomNavbar(),
    );
  }

  BottomNavigationBar buildBottomNavbar() {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentScreen,
      fixedColor: primaryColor,
      onTap: (value) {
        setState(() {
          _currentScreen = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  _DefaultScreenState(this._currentScreen);
}
