import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:fluttergram/constants.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  List<String> items = ['Anna', 'Lucas', 'John', 'Maria', 'A', 'B'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
            title: Text("COSMOS")
        ),
        body: Column(
          children: [
            SizedBox(
              height: 100,
              child: buildPost(),
            ),
            Divider(
                color: Colors.grey
            ),
            Expanded(
                child: buildListComment()
            )
          ],
        ),
        bottomNavigationBar: navarBar()
    );
  }
  Widget buildListComment() => ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index){
        final item = items[index];
        return ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage('https://i.pinimg.com/736x/5b/19/fb/5b19fb0aaa68f8b856a093b64431631f.jpg'),
          ),
          // trailing: IconButton(
          //   icon: Icon(
          //     Icons.favorite_border,
          //   ),
          //   color: Colors.grey,
          //   onPressed: () {},
          // ),
          trailing: Text("10 hours ago"),
          title: Text(item),
          subtitle: Text('Hello'),
          onTap: (){},
        );
      }
  );
  Widget buildPost() => ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index){
        final item = items[index];
        return ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage('https://i.pinimg.com/736x/5b/19/fb/5b19fb0aaa68f8b856a093b64431631f.jpg'),
          ),
          title: Text('Son'),
          subtitle: Text('Hom nay troi dep qua lo ldneiwo mfoewpmkwp mekpwmd mdwqlp,c modwpqm ,dqp qqwwwasd dwqjipmlx;cw'),
          onTap: (){},
        );
      }
  );
  Widget navarBar() => Container(
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 6.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.all(20.0),
                  hintText: 'Add a comment',
                  prefixIcon: Container(
                    margin: EdgeInsets.all(4.0),
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          height: 48.0,
                          width: 48.0,
                          image: NetworkImage('https://i.pinimg.com/736x/5b/19/fb/5b19fb0aaa68f8b856a093b64431631f.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  suffixIcon: Container(
                    margin: EdgeInsets.only(right: 4.0),
                    width: 70.0,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: primaryColor,
                          primary: primaryColor
                      ),
                      onPressed: () => print('Post comment'),
                      child: Icon(
                        Icons.send,
                        size: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  )
              )
          )
      )
  );
}