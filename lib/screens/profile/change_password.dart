import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';

import '../../constants.dart';
import '../../default_screen.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassWord = TextEditingController();
  TextEditingController newPassWord = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('COSMOS'),
          backgroundColor: primaryColor,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(10, 70, 10, 30),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: passwordTextField(oldPassWord, "Old Password"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: passwordTextField(newPassWord, "New Password"),
                  ),
                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: pressedColor,
                              textStyle: TextStyle(color: secondaryColor)
                          ),
                          child: Text('Change Password'),
                          onPressed: () async {
                            String oldPass = oldPassWord.text;
                            String newPass = newPassWord.text;
                            int statusCode = await changePassword(oldPass, newPass);
                            if (statusCode>300){
                              changePassAlert(context, "error",
                                  "Change password unsuccessfully.", "Retry");
                            }
                            else {
                              changePassAlertSuccess(context, "ok", "Change password successfully.", "OK");
                            }
                          }
                      )
                  )
                ]
            )
        )
    );
  }
}
class passwordTextField extends StatefulWidget{
  TextEditingController textController;
  String label;
  @override
  State<StatefulWidget> createState() => _PasswordTextFieldState();

  passwordTextField(this.textController, this.label);
}

class _PasswordTextFieldState extends State<passwordTextField>{
  bool isPasswordTextField = true;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: widget.textController,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: widget.label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )
        ),
      ),
    );
  }
}

changePassAlert(BuildContext context, String type, String message, String button) {
  Color textColor = primaryColor;
  switch (type) {
    case "error":
      textColor = errorColor;
      break;
    case "warning":
      textColor = warningColor;
      break;
  }
  // set up the button
  Widget okButton = TextButton(
    child: Text(button, style: TextStyle(color: textColor)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: secondaryColor,
    title: Text(message, style: TextStyle(color: textColor)),
    // content: const Text("You have created a new COSMOS account!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

changePassAlertSuccess(BuildContext context, String type, String message, String button) {
  Color textColor = primaryColor;
  switch (type) {
    case "ok":
      textColor = primaryColor;
      break;
    case "warning":
      textColor = warningColor;
      break;
  }
  // set up the button
  Widget okButton = TextButton(
    child: Text(button, style: TextStyle(color: textColor)),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DefaultScreen(currentScreen: 3)
        ),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: secondaryColor,
    title: Text(message, style: TextStyle(color: textColor)),
    // content: const Text("You have created a new COSMOS account!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}