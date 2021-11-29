
import 'package:flutter/material.dart';
import 'package:fluttergram/models/user_model.dart';

class Story extends StatelessWidget {
  final List<User> friends;
  final User currentUser;

  Story({Key? key, required this.friends, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      color: Colors.white,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 4.0,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: 1 + friends.length,
          itemBuilder: (BuildContext context, int index) {
            String imageUrl;
            if (currentUser.avatar!.filename != '') {
              imageUrl = currentUser.avatar!.filename;
            } else {
              imageUrl = "https://icon-library.com/images/unknown-person-icon/unknown-person-icon-4.jpg";
            }
            if (index == 0) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                                    radius: 20.0,
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: NetworkImage(imageUrl),
                                    ),
                                  ),
                    ),
                    Text(
                      'Your Story',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ]);
            }
            final User user = friends[index - 1];
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        radius: 20.0,
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(user.avatar!.filename),
                        ),
                      ),
                  ),
                  Text(
                    user.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ]);
          }),
    );
  }
}
