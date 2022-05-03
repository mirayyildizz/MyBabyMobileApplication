import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:baby/pages/progress.dart';
import 'package:baby/pages/timeline.dart' as timeL;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby/pages/user.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'activity_feed.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot>? searchResultsFuture;

 handleSearch(String query){
    print(query);
    Future<QuerySnapshot> users = timeL.usersRef
        //.where("userName", isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultsFuture = users;

    });

  }





  clearSearch(){
    searchController.clear();
  }

  AppBar buildSearchField(){
    return AppBar(
        automaticallyImplyLeading: false,
    backgroundColor : Colors.deepOrange,
    title: TextFormField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search a user..",
        filled: true,
        prefixIcon:  Icon(
          Icons.account_box,
          size: 20.0,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: clearSearch,
        ),
      ),
      onFieldSubmitted: handleSearch,
    )
  );
  }

  Container buildNoContent(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container (
      child: Center(
        child: ListView (
          shrinkWrap: true,
          children : <Widget> [
            SvgPicture.asset('assets/images/searchnew.svg', height: orientation == Orientation.portrait ? 300.0 : 200.0),
        /*Text("Find Users", textAlign: TextAlign.center, style:
            TextStyle(
              color: Colors.deepOrange,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 35.0,


            ),
            ) */
          ]
        ),
      ),
    );
  }

  buildSearchResults(){
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return circularProgress();
        }
        List<UserResult> searchResults = [];
      //  timeL.usersRef.get().then((QuerySnapshot snapshot) {
          snapshot.data!.docs.forEach((doc) {
            User user = User.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            print(user.userName);
            searchResults.add(searchResult);
          });
       // });
        return ListView(
          children: searchResults,
        );

      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.withOpacity(0.4),
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent():
      buildSearchResults(),

    );
  }
}


class UserResult extends StatelessWidget {
  final User user;
  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(children: <Widget>[
        GestureDetector(
          onTap: () => showProfile(context, profileId: user.id),
          child: ListTile(
            /*leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            ),*/
            title: Text(user.userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            subtitle: Text(user.userName, style: TextStyle(color: Colors.white),),
          )
        ),
        Divider(
          height: 2.0,
          color: Colors.white54,
        ),
      ],)
    );
  }
}