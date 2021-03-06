import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/util/util.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../default_screen.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({
    Key? key,
    required this.user,
    // required this.onPressed
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _EditProfileState(user.avatar!.fileName);
}

class _EditProfileState extends State<EditProfile> {
  ImagePicker imagePicker = new ImagePicker();
  File imageFileAvt = new File('');
  String imageFilePath;
  _EditProfileState(this.imageFilePath);
  String imageEncode = '';
  String genderText = '';
  @override
  Widget build(BuildContext context) {
    return buildApp(widget.user);
  }

  Container editProfileContainer(
      TextEditingController controller, String label) {
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

  Widget buildApp(User user) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: secondaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text("COSMOS"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: primaryColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageFileAvt.path != ''
                                  ? FileImage(imageFileAvt) as ImageProvider
                                  : getImageProviderNetWork(imageFilePath))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 4, color: secondaryColor),
                              color: primaryColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _selectImage(context);
                              },
                            ))),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Username", user.username, usernameController),
              buildTextField("Bio", user.description.toString(), descriptionController),
              Text(
                'Gender',

              ),
              DropdownButton<String>(
                isExpanded: true,
                value: genderText!=''?genderText:user.gender,
                items: <String>['Secret', 'Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    genderText = value!;
                  });
                },
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String username = usernameController.text;
                      String description = descriptionController.text;
                      if (genderText == ''){
                        genderText = user.gender!;
                      }
                      int statusCode = await edit(
                          username, description, genderText, imageEncode);
                      if (statusCode < 300) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DefaultScreen(currentScreen: 3)),
                            ModalRoute.withName('/'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, TextEditingController tec) {
    tec.text = placeholder;
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: tec,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Open Camera'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? imageFile = (await imagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80));
                  setState(() {
                    imageFileAvt = File(imageFile!.path);
                  });
                  imageEncode = await encodeFile(imageFileAvt);
                }),
            SimpleDialogOption(
                child: const Text('Upload photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile? selectedImages = await imagePicker.pickImage(
                    maxWidth: 1920,
                    maxHeight: 1200,
                    imageQuality: 80,
                    source: ImageSource.gallery,
                  );

                  if (selectedImages != null) {
                    setState(() {
                      imageFileAvt = File(selectedImages.path);
                    });
                  } else {
                    changeAvtAlert(context, "Please choose a image");
                  }
                  imageEncode = await encodeFile(imageFileAvt);
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  changeAvtAlert(BuildContext context, String message) {
    Color textColor = errorColor;
    Widget okButton = TextButton(
      child: Text("OK", style: TextStyle(color: textColor)),
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
}
