import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/models/user_model.dart';
import '../../util/util.dart';
import 'package:fluttergram/default_screen.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import '../../socket/custom_socket.dart';
import 'error_connection.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LogInState();
}

class _LogInState extends State<LogInPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool _validatePhone = true;
  bool _validatePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('COSMOS')),
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
                      'Welcome!',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone No.',
                        errorBorder: OutlineInputBorder(),
                        errorText: _validatePhone ? null : "Invalid phone number"
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    obscureText: !showPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        errorText: _validatePassword ? null : "Invalid password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: !showPassword
                              ? Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                )
                              : Icon(Icons.visibility_off, color: Colors.grey),
                        )),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: pressedColor,
                          textStyle: TextStyle(color: secondaryColor)),
                      child: Text('LOG IN', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        String phone = phoneController.text;
                        String password = passwordController.text;
                        setState(() {
                          _validatePassword = passwordValidation(password)[0];
                          _validatePhone = phoneValidation(phone)[0];
                        });
                        if (_validatePhone && _validatePassword) {
                          var currentUserAndToken = await logIn(
                              phone, password);
                          if (currentUserAndToken[0].id != "-1" && currentUserAndToken[0].id != "-2") {
                            User currentUser = currentUserAndToken[0];
                            String token = currentUserAndToken[1];
                            await setToken(token);
                            await setCurrentUserId(currentUser.id);
                            await initGlobalCustomSocket(currentUser.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DefaultScreen(
                                        currentScreen: 0,
                                      )),
                            );
                          } else if (currentUserAndToken[0].id == "-2")  {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => ErrorScreen()
                                    ),
                                ModalRoute.withName('/error'));
                          }
                          else {
                            logInAlert(context, "error",
                                "Logged in unsuccessfully.", "Retry");
                          }
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
  TextEditingController confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _validatePhone = true;
  bool _validatePassword = true;
  bool _validateConfirmPassword = true;
  bool _validateFirstName = true;
  bool _validateLastName = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('COSMOS')),
          backgroundColor: primaryColor,
        ),
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
                signUpContainer(firstNameController, "First Name", _validateFirstName),
                signUpContainer(lastNameController, "Last Name", _validateLastName),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone No.',
                      errorBorder: OutlineInputBorder(),
                      errorText: _validatePhone ? null : "Invalid phone number"
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: !_showPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        errorText: _validatePassword ? null : "Invalid password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: !_showPassword
                              ? Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                )
                              : Icon(Icons.visibility_off, color: Colors.grey),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      errorText: _validateConfirmPassword ? null : "Confirm password does not match",
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
                      child: Text('SIGN UP', style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: () async {
                        String phone = phoneController.text;
                        String password = passwordController.text;
                        String confirmPassword = confirmPasswordController.text;
                        String username = firstNameController.text +
                            " " +
                            lastNameController.text;

                        setState(() {
                          _validatePhone = phoneValidation(phone)[0];
                          _validatePassword = passwordValidation(password)[0];
                          _validateConfirmPassword = confirmPasswordValidation(confirmPassword, password)[0];
                          _validateFirstName = firstNameController.text != "";
                          _validateLastName = lastNameController.text != "";
                        });

                        if (_validateFirstName && _validateLastName && _validatePhone && _validatePassword && _validateConfirmPassword) {
                          int statusCode =
                          await signUp(username, phone, password);
                          if (statusCode < 300) {
                            signUpAlert(context, "success",
                                "Sign Up Successfully", "Let's Log in");
                          } else {
                            signUpAlert(context, "error",
                                "Unable to sign up.", "Retry");
                          }
                        }
                      },
                    ))
              ],
            )));
  }

  Container signUpContainer(TextEditingController controller, String label, bool _validate) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          errorText: _validate ? null : "This field can not be empty!",
          errorBorder: OutlineInputBorder()
        ),
      ),
    );
  }
}

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
