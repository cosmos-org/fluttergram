import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'conversation_search_result.dart';


import '../../constants.dart';
import 'package:fluttergram/controllers/conversation/conversation_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/models/conversation_model.dart';


const headerTextColor = Colors.lightBlue;
const headerFontSize = 24.0;
const headerFontWeight = FontWeight.bold;

class SearchConversationScreen extends StatefulWidget {
  List<Conversation> conversations;
  SearchConversationScreen({Key? key,required this.conversations}) : super(key: key);
  @override
  _SearchConversationScreenState createState() => _SearchConversationScreenState();
}

class _SearchConversationScreenState extends State<SearchConversationScreen> {

  String selectedTerm = 'a';




  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child:TextField(
//    ...,other fields
                decoration: InputDecoration(
                    prefixIcon: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    suffixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  print(value);
                  setState((){
                    print(value);
                    selectedTerm = value;
                  });
                }
            ),
          ),
          SizedBox(
            height:  20,
          ),
          ConversationSearchResultsListView(searchTerm: selectedTerm,conversations:widget.conversations),
        ],),
      );
  }

}

class ConversationSearchResultsListView extends StatelessWidget {
  final String? searchTerm;
  final List<Conversation>? conversations;
  const ConversationSearchResultsListView({
    Key? key,
    @required this.searchTerm,
    @required this.conversations,
  }) : super(key: key);
  List<User> extractUserFromConversations(List<Conversation> convers){
   var  userLs = <User>[];
    for (var element in convers)
      // resp['data'].foreach((element)
        {
      userLs.add(element.partnerUser ?? User.fromJson({}));
    };
    return userLs;
  }
  @override
  Widget build(BuildContext context) {
    if (searchTerm == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }
    if (searchTerm == '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      );
    }

    return  FutureBuilder<List<Conversation>>(
      future: searchConversationAPI(searchTerm ?? '', conversations!),
      builder: (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // data loaded:
          final conversations = snapshot.data!;
          if (conversations.length > 0)
            return ConversationSearchedList(conversations: conversations);
          else
            return  Center(
              child: Text(
                  'No users found',
                  style: TextStyle(fontSize: headerFontSize*0.75 ,fontWeight:headerFontWeight)),
            );
        }
      },
    );
  }
}