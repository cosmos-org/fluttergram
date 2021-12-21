import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/constants.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/util/util.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:fluttergram/controllers/post_controller.dart';
import 'package:video_player/video_player.dart';
import '../../default_screen.dart';

class CreatePost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  ImagePicker imagePicker = new ImagePicker();
  late VideoPlayerController videoPlayerController;
  List<File> images = [];
  List<File> videos = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getCurrentUser(),
        builder: (ctx, snapshot) {
          return Scaffold(
              appBar: AppBar(
                  backgroundColor: primaryColor,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: secondaryColor),
                      onPressed: () {
                        deletePostAlert(context);
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
                          List<String> encodeVideos = await encodeFiles(videos);
                          int statusCode =
                              await createPost(description, encodeImages, encodeVideos);
                          print(statusCode);
                          if (statusCode < 300) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DefaultScreen(currentScreen: 0)),
                                ModalRoute.withName("/Home"));
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
                      snapshot.data != null
                          ? CircleAvatar(
                              backgroundImage: getImageProviderNetWork(
                                  snapshot.data!.avatar!.fileName))
                          : const SizedBox(),
                      Container(
                        width: 250.0,
                        child: TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              hintText: "Write a caption...",
                              border: InputBorder.none),
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
                  ),
                  images.isNotEmpty
                      ? Center(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                            ),
                            items: images
                                .map((img) => ClipRRect(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.file(img),
                                          ),
                                          Positioned(
                                              right: -2,
                                              top: -5,
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    size: 18,
                                                  ),
                                                  onPressed: () => setState(() {
                                                        images.remove(img);
                                                      })))
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                      : const SizedBox.shrink(),
                  videos.isNotEmpty
                      ? Center(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                            ),
                            items: videos
                                .map((vid) => ClipRRect(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: VideoPlayer(
                                                  videoPlayerController)),
                                          Positioned(
                                              right: -2,
                                              top: -5,
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    size: 18,
                                                  ),
                                                  onPressed: () => setState(() {
                                                        videos.remove(vid);
                                                      })))
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ));
        });
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
                    images.add(File(imageFile!.path));
                  });
                }),
            SimpleDialogOption(
                child: const Text('Upload photos'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  List<XFile>? selectedImages =
                      await imagePicker.pickMultiImage(
                    maxWidth: 1920,
                    maxHeight: 1200,
                    imageQuality: 80,
                  );
                  if (selectedImages!.isNotEmpty &&
                      selectedImages.length <= 4) {
                    setState(() {
                      images.addAll(
                          selectedImages.map((xImg) => File(xImg.path)));
                      videos = [];
                    });
                  } else {
                    setState(() {
                      images = [];
                    });
                    //TODO Alert for exceeding number of images
                  }
                }),
            SimpleDialogOption(
                child: const Text('Upload video'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? videoFile = (await imagePicker.pickVideo(
                      source: ImageSource.gallery));
                  File video = File(videoFile!.path);
                  videoPlayerController = VideoPlayerController.file(video)
                    ..initialize().then((_) {
                      setState(() {
                        images = [];
                        videos.add(File(videoFile.path));
                      });
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

deletePostAlert(BuildContext context) {
  Color textColor = primaryColor;
  // set up the button
  Widget deleteButton = TextButton(
    child: Text("Delete", style: TextStyle(color: errorColor)),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    },
  );

  Widget cancelButton = TextButton(
    child: Text("Cancel", style: TextStyle(color: textColor)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: secondaryColor,
    title: Text("The post is not saved. Do you want to delete it?", style: TextStyle(color: textColor)),
    actions: [
      cancelButton,
      deleteButton
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

postingFailAlert(context) {
  Color textColor = primaryColor;
  // set up the button
  Widget backHomeButton = TextButton(
    child: Text("Back to Home", style: TextStyle(color: textColor)),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    },
  );

  Widget retryButton = TextButton(
    child: Text("Retry", style: TextStyle(color: textColor)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: secondaryColor,
    title: Text("Couldn't post. Something wrong!", style: TextStyle(color: textColor)),
    actions: [
      backHomeButton,
      retryButton
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
