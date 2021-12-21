import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/screens/search/user_search_result.dart';
import 'package:fluttergram/screens/search/post_search_result.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../constants.dart';
import 'package:fluttergram/controllers/search_controller.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/models/post_model.dart';


const headerTextColor = Colors.lightBlue;
const headerFontSize = 24.0;
const headerFontWeight = FontWeight.bold;

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const historyLength = 5;

  List<String> _searchHistory = [
    'flutter',
    'cosmos',
    'fluttergram',
  ];

  late List<String> filteredSearchHistory;

  late String selectedTerm = '';

  List<String> filterSearchTerms({
    @required String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      body: FloatingSearchBar(

        // leadingActions: [const Icon(Icons.view_list)],
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ,
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search and find out...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                          title: Text(
                            term,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: const Icon(Icons.history),
                          trailing: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                deleteSearchTerm(term);
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              putSearchTermFirst(term);
                              selectedTerm = term;
                            });
                            controller.close();
                          },
                        ),
                      )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: primaryColor,
        title:  Center(
          child: Text('Search'),
        ),
        leading: IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () {},
          ),
        ]);
  }
}

class SearchResultsListView extends StatelessWidget {
  final String? searchTerm;

  const SearchResultsListView({
    Key? key,
    @required this.searchTerm,
  }) : super(key: key);

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
    final fsb = FloatingSearchBar.of(context);

    return Column(
        children : [
          SizedBox(
            height: fsb.height + 20,
          ),
          Text(
              'Users',
              style: TextStyle(fontSize: headerFontSize ,fontWeight:headerFontWeight,color: headerTextColor)
          ),
          SizedBox(
            height:  20,
          ),
          FutureBuilder<List<User>>(
            future: getSearchUserResultAPI(searchTerm),
            builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (!snapshot.hasData) {
                // while data is loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // data loaded:
                final searchedUsers = snapshot.data!;
                if (searchedUsers.length > 0)
                  return UserSearchedList(users: searchedUsers);
                else
                  return  Center(
                    child: Text(
                        'No users found',
                        style: TextStyle(fontSize: headerFontSize*0.75 ,fontWeight:headerFontWeight)),
                  );
              }
            },
          ),
          Divider(
            color: Colors.blueAccent,
          ),
          SizedBox(
            height:  10,
          ),
          Text(
              'Posts',
              style: TextStyle(fontSize: headerFontSize ,fontWeight:headerFontWeight,color: headerTextColor)
          ),
          SizedBox(
            height:  10,
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
            future: getSearchPostResultAPI(searchTerm),
            builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
              if (!snapshot.hasData) {
                // while data is loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // data loaded:
                final searchedPosts = snapshot.data!;
                if (searchedPosts.length > 0)
                  return PostSearchedList(posts: searchedPosts);
                else
                  return Center(
                      child: Text(
                          'No posts found',
                          style: TextStyle(fontSize: headerFontSize*0.75 ,fontWeight:headerFontWeight)),
                  );
              }
            },
          ),),
        ]
    );
  }
}