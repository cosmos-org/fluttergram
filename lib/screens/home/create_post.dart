// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttergram/constants.dart';
//
// import 'gallery_image.dart';
// import 'home_screen.dart';
//
// enum ImageSourceType { gallery, camera }
//
// class CreatePost extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _CreatePostState();
// }
//
// class _CreatePostState extends State<CreatePost> {
//   TextEditingController captionController = new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(),
//       body: Column(
//         children: [
//           Container(
//             height: 60,
//             margin: EdgeInsets.all(10),
//             child: TextField(
//                 controller: captionController,
//                 decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                     borderSide: const BorderSide(
//                         color: Colors.grey, width: 0.5),
//                   ),
//                   hintText: "What's in your mind?",
//                 )),
//           ),
//           IconButton(
//             icon: Icon(Icons.add_photo_alternate),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           GalleryImage()));
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   AppBar buildAppBar() {
//     return AppBar(
//         backgroundColor: primaryColor,
//         title: Center(
//           child: Text('Create Post'),
//         ),
//         actions: [
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                   primary: primaryColor,
//                   textStyle: TextStyle(
//                     color: secondaryColor,
//                     fontSize: usernameFontSize,
//                     fontWeight: FontWeight.bold,
//                   )),
//               child: Text("Post"))
//         ]);
//   }
// }
