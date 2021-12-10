import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryImage extends StatefulWidget {
  GalleryImage();
  @override
  GalleryImageState createState() => GalleryImageState();
}

class GalleryImageState extends State<GalleryImage> {
  var _image;
  var imagePicker;


  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Choose from Gallery")),
        body: Column(children: <Widget>[
          SizedBox(
            height: 52,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                XFile? image =
                await imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = File(image!.path);
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                  _image,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.fitHeight,
                )
                    : Container(
                  child: Text("No Images Selected"),
                  // decoration: BoxDecoration(
                  //     color: Colors.red[200]),
                  // width: 200,
                  // height: 200,
                  // child: Icon(
                  //   Icons.camera_alt,
                  //   color: Colors.grey[800],
                ),
              ),
            ),
          ),
        ]));
  }
}
