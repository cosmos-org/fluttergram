import 'package:flutter/material.dart';
import 'package:fluttergram/controllers/user_controller.dart';
import 'package:fluttergram/models/profile_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile/different_user_profile.dart';
import '../../constants.dart';
import '../../default_screen.dart';
import '../../util/util.dart';
const String getFileUrl = hostname+ '/files/';

class UserSearchedList extends StatelessWidget {
  final List<User> users;
  UserSearchedList({Key? key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
      height: 110.0,
      color: Colors.white,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 10, // set spacing here
            children: createUserList(users),
          )
      ),
    );
  }
}

List<Widget> createUserList(userList) {
  var ls = <UserSearched>[];
  userList.forEach((ele) {
    ls.add(new UserSearched(user: ele));
  });

  return ls;
}
class UserSearched extends StatelessWidget {
  final User user;
  UserSearched({Key? key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 104,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(
              color: Colors.blue,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),

          child: InkWell(
            onTap: () async{
              if (user.id == await getCurrentUserId()){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DefaultScreen(currentScreen: 3)),
                    ModalRoute.withName('/'));
              }
              else {
                Profile profile = await showAnotherProfile(user.id);
                String status = await getStatusUser(user.id);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DUserProfileScreen(profile: profile, status: status))
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                          height: 32,
                          width: 32,
                          child: ClipOval(
                            child: getImageNetWork(user.avatar!.fileName),
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.username,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: "Roboto",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              user.gender.toString() + ", " + user.birthday.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: "Roboto",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //for user profile header

                //performace bar

                SizedBox(
                  height: 5,
                ),
                Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.description,
                        color: Colors.black,
                        size: 16.0,
                        semanticLabel:
                        'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text( (user.description != '') ? user.description ?? 'About me' : 'About me',
                        overflow: TextOverflow.ellipsis,)
                    ])),
                Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.black,
                        size: 16.0,
                        semanticLabel:
                        'Text to announce in accessibility modes',
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text( (user.address != '') ? user.address ?? 'Viet Nam' : 'Viet Nam',
                        overflow: TextOverflow.ellipsis,
                      )
                    ]))
                //Container for client
              ],
            ),
          )),
    );
  }
}
