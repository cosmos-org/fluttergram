import 'package:flutter/material.dart';
import 'package:fluttergram/screens/login/login_screen.dart';

import '../../constants.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('COSMOS')),
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: Center(
          child: Column (
            children: [
              SizedBox(height: 150),
              SizedBox(
                child: Icon(Icons.wifi_off_sharp,
                size: 60,
                color: Colors.grey,),
              ),
              SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Text("Sorry we lost the connection to server.",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey
                      )
                  ),
                  TextButton(
                    style: TextButton.styleFrom(primary: errorColor),
                    child: const Text(
                      'Try again',
                      style: TextStyle(
                          fontSize: 15, decoration: TextDecoration.underline),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LogInPage()
                          ),
                          ModalRoute.withName('/'));
                      }
                      )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
          )

        )
      )
    );
  }

}