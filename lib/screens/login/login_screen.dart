import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/models/user_model.dart';

import 'package:fluttergram/default_screen.dart';
import 'package:fluttergram/controllers/user_controller.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LogInState();
}

class _LogInState extends State<LogInPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('COSMOS'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10, 70, 10, 30),
                    child: const Text(
                      'Welcome!',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: pressedColor,
                          textStyle: TextStyle(color: secondaryColor)),
                      child: Text('Log in'),
                      onPressed: () async {
                        String phone = phoneController.text;
                        String password = passwordController.text;
                        User currentUser = await logIn(phone, password);
                        if (currentUser.id != "-1") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DefaultScreen()),
                          );
                        } else {
                          logInAlert(context, "error",
                              "Logged in unsuccessfully.", "Retry");
                        }
                      },
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    const Text("Haven't got any account?",
                        style: TextStyle(fontSize: 13)),
                    TextButton(
                      style: TextButton.styleFrom(primary: primaryColor),
                      child: const Text(
                        'Create a new one',
                        style: TextStyle(
                            fontSize: 15, decoration: TextDecoration.underline),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("COSMOS")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    )),
                signUpContainer(firstNameController, "First Name"),
                signUpContainer(lastNameController, "Last Name"),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone No.',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: pressedColor,
                          textStyle: TextStyle(color: secondaryColor)),
                      child: Text('Sign Up'),
                      onPressed: () async {
                        print("Sign Up request");

                        String phone = phoneController.text;
                        String password = passwordController.text;
                        String username = firstNameController.text +
                            " " +
                            lastNameController.text;

                        // String body = '{"username": "$username", '
                        //     '"phonenumber": "$phone",'
                        //     '"password": "$password"}';
                        // Map<String, String> headers = {"Content-type": "application/json"};
                        // Response resp = await post(Uri.parse(signupUrl), headers: headers, body: body);
                        // int statusCode = resp.statusCode;
                        // print(statusCode);
                        int statusCode =
                            await signUp(username, phone, password);
                        if (statusCode < 300) {
                          signUpAlert(context, "success",
                              "Sign Up Successfully", "Let's Log in");
                        } else {
                          signUpAlert(context, "error",
                              "Sign up unsuccessfully", "Retry");
                        }
                      },
                    ))
              ],
            )));
  }

  Container signUpContainer(TextEditingController controller, String label) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}

inputValidation(String username, String phone, String password) {}

logInAlert(BuildContext context, String type, String message, String button) {
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

signUpAlert(BuildContext context, String type, String message, String button) {
  Color textColor = primaryColor;
  if (type == "error") {
    textColor = errorColor;
  }
  // set up the button
  Widget okButton = TextButton(
    child: Text(button, style: TextStyle(color: textColor)),
    onPressed: () {
      if (type == "success") {
        Navigator.of(context).pop();
      }
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: secondaryColor,
    title: Text(message, style: TextStyle(color: textColor)),
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
