import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:fluttergram/controllers/post_controller.dart';

import '../../default_screen.dart';
// import 'location.dart';
// import 'package:geocoder/geocoder.dart';

// class Uploader extends StatefulWidget {
//   _Uploader createState() => _Uploader();
// }
//
// class _Uploader extends State<Uploader> {
//   var file = null;
//   //Strings required to save address
//   // Address address;
//
//   Map<String, double> currentLocation = Map();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   ImagePicker imagePicker = ImagePicker();
//
//   bool uploading = false;
//
//   @override
//   initState() {
//     //variables with location assigned as 0.0
//     currentLocation['latitude'] = 0.0;
//     currentLocation['longitude'] = 0.0;
//     // initPlatformState(); //method to call location
//     super.initState();
//   }
//
//   // //method to get Location and save into variables
//   // initPlatformState() async {
//   //   Address first = await getUserLocation();
//   //   setState(() {
//   //     address = first;
//   //   });
//   // }
//
//   Widget build(BuildContext context) {
//     return file == null
//         ? Scaffold(
//             appBar: AppBar(
//                 backgroundColor: primaryColor,
//                 leading: IconButton(
//                     icon: Icon(Icons.arrow_back, color: secondaryColor),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     }),
//                 title: const Text(
//                   'Select Image',
//                   style: const TextStyle(color: secondaryColor),
//                 )),
//             body: Center(
//               child: IconButton(
//                   icon: Icon(Icons.add_photo_alternate),
//                   onPressed: () => {_selectImage(context)}),
//             ))
//         : Scaffold(
//             resizeToAvoidBottomInset: false,
//             appBar: AppBar(
//               backgroundColor: secondaryColor,
//               leading: IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.black),
//                   onPressed: clearImage),
//               title: const Text(
//                 'Post to',
//                 style: const TextStyle(color: Colors.black),
//               ),
//               actions: <Widget>[
//                 FlatButton(
//                     onPressed: () {
//                       print(descriptionController.text);
//                       print(locationController.text);
//                       // TODO Create new Post API
//                     },
//                     child: Text(
//                       "Post",
//                       style: TextStyle(
//                           color: primaryColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0),
//                     ))
//               ],
//             ),
//             body: ListView(
//               children: <Widget>[
//                 PostForm(
//                   imageFile: file,
//                   descriptionController: descriptionController,
//                   locationController: locationController,
//                   loading: uploading,
//                 ),
//                 Divider(), //scroll view where we will show location to users
//                 // SingleChildScrollView(
//                 //   scrollDirection: Axis.horizontal,
//                 //   padding: EdgeInsets.only(right: 5.0, left: 5.0),
//                 //   child: Row(
//                 //     children: <Widget>[
//                 //       buildLocationButton(address.featureName),
//                 //       buildLocationButton(address.subLocality),
//                 //       buildLocationButton(address.locality),
//                 //       buildLocationButton(address.subAdminArea),
//                 //       buildLocationButton(address.adminArea),
//                 //       buildLocationButton(address.countryName),
//                 //     ],
//                 //   ),
//                 // ),
//                 // (address == null) ? Container() : Divider(),
//               ],
//             ));
//   }
//
//   //method to build buttons with location.
//   buildLocationButton(String locationName) {
//     if (locationName != null ?? locationName.isNotEmpty) {
//       return InkWell(
//         onTap: () {
//           locationController.text = locationName;
//         },
//         child: Center(
//           child: Container(
//             //width: 100.0,
//             height: 30.0,
//             padding: EdgeInsets.only(left: 8.0, right: 8.0),
//             margin: EdgeInsets.only(right: 3.0, left: 3.0),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//             child: Center(
//               child: Text(
//                 locationName,
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
//
//   _selectImage(BuildContext parentContext) async {
//     return showDialog<Null>(
//       context: parentContext,
//       barrierDismissible: false, // user must tap button!
//
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: <Widget>[
//             // SimpleDialogOption(
//             //     child: const Text('Take a photo'),
//             //     onPressed: () async {
//             //       Navigator.pop(context);
//             //       XFile? imageFile = (await imagePicker.pickImage(
//             //           source: ImageSource.camera,
//             //           maxWidth: 1920,
//             //           maxHeight: 1200,
//             //           imageQuality: 80));
//             //       setState(() {
//             //         file = File(imageFile!.path);
//             //       });
//             //     }),
//             SimpleDialogOption(
//                 child: const Text('Choose from Gallery'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   XFile? imageFile = (await imagePicker.pickImage(
//                       source: ImageSource.gallery,
//                       maxWidth: 1920,
//                       maxHeight: 1200,
//                       imageQuality: 80));
//                   setState(() {
//                     file = File(imageFile!.path);
//                   });
//                 }),
//             SimpleDialogOption(
//               child: const Text("Cancel"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
//
//   void clearImage() {
//     setState(() {
//       file = null;
//     });
//   }
//
//   // void postImage() {
//   //   setState(() {
//   //     uploading = true;
//   //   });
//   //   uploadImage(file).then((String data) {
//   //     // postToFireStore(
//   //     //     mediaUrl: data,
//   //     //     description: descriptionController.text,
//   //     //     location: locationController.text);
//   //   }).then((_) {
//   //     setState(() {
//   //       // file = null;
//   //       uploading = false;
//   //     });
//   //   });
//   // }
// }
//
// class PostForm extends StatelessWidget {
//   final imageFile;
//   final TextEditingController descriptionController;
//   final TextEditingController locationController;
//   final bool loading;
//   PostForm(
//       {this.imageFile,
//       required this.descriptionController,
//       required this.loading,
//       required this.locationController});
//
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         loading
//             ? LinearProgressIndicator()
//             : Padding(padding: EdgeInsets.only(top: 0.0)),
//         Divider(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             CircleAvatar(
//                 // TODO Get User's Avatar
//                 // backgroundImage: NetworkImage(currentUserModel.photoUrl),
//                 ),
//             Container(
//               width: 250.0,
//               child: TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                     hintText: "Write a caption...", border: InputBorder.none),
//               ),
//             ),
//             Container(
//               height: 45.0,
//               width: 45.0,
//               child: AspectRatio(
//                 aspectRatio: 487 / 451,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                     fit: BoxFit.fill,
//                     alignment: FractionalOffset.topCenter,
//                     image: imageFile != null
//                         ? FileImage(imageFile)
//                         : FileImage(File("assets/whatsapp_Back.png")),
//                   )),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Divider(),
//         ListTile(
//           leading: Icon(Icons.pin_drop),
//           title: Container(
//             width: 250.0,
//             child: TextField(
//               controller: locationController,
//               decoration: InputDecoration(
//                   hintText: "Where was this photo taken?",
//                   border: InputBorder.none),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

class CreatePost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  List<File> images = [];
  bool loading = false;
  ImagePicker imagePicker = new ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: secondaryColor),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: const Center(
                child: Text(
              'New Post',
              textAlign: TextAlign.center,
              style: const TextStyle(color: secondaryColor),
            )),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    String description = descriptionController.text;
                    List<String> encodeImages = await encodeFiles(images);
                    // List<String> encodeVideos = await encodeFiles(videos);
                    int statusCode = await createPost(description, encodeImages, []);
                    print(statusCode);
                    if (statusCode < 300) {
                      Navigator.pop(context);
                    }
                    // TODO Alert posting failed
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ))
            ]),
        body: Column(
          children: <Widget>[
            loading
                ? LinearProgressIndicator()
                : Padding(padding: EdgeInsets.only(top: 0.0)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircleAvatar(
                    // TODO Get User's Avatar
                    // backgroundImage: NetworkImage(currentUserModel.photoUrl),
                    ),
                Container(
                  width: 250.0,
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: "Write a caption...",
                        border: InputBorder.none),
                  ),
                ),
                Container(
                  height: 45.0,
                  width: 45.0,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: images.isNotEmpty
                            ? FileImage(images[0])
                            : FileImage(File("assets/whatsapp_Back.png")),
                      )),
                    ),
                  ),
                ),
                Center(
                  child: IconButton(
                      icon: Icon(Icons.add_photo_alternate),
                      onPressed: () => {_selectImage(context)}),
                ),
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.pin_drop),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                      hintText: "Where was this photo taken?",
                      border: InputBorder.none),
                ),
              ),
            )
          ],
        ));
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
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? imageFile = (await imagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80));
                  setState(() {
                    images.add(File(imageFile!.path));
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile? xFile = (await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80));
                  setState(() {
                    if (images.length < 4) {
                      images.add(File(xFile!.path));
                    } else {
                      //TODO Alert for exceeding number of images
                    }
                  });
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

  void clearImage() {
    setState(() {
      images = [];
    });
  }

  Future<List<String>> encodeFiles(List<dynamic> files) async {
    List<String> encodedLists = [];
    for (File file in files) {
      var bytes = (await file.readAsBytes());
      String base64Encode = base64.encode(bytes);
      encodedLists.add(base64Encode);
    }
    return encodedLists;
  }
}
