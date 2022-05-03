

import 'package:flutter/material.dart';
import 'package:baby/pages/post.dart';
import 'package:baby/pages/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby/pages/search.dart';
import 'package:baby/pages/suggestFriends.dart';
import 'package:baby/pages/user.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Start.dart';
import 'home.dart';
import 'home.dart';

String namee = "";
String uid = "";

final usersRef =  FirebaseFirestore.instance.collection('users');


class Timeline extends StatefulWidget {

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  late List<Post> posts = [];

  List<String> followingList = [];
  List<Post> followersPosts = [];
  @override
  void initState(){
    super.initState();
    getUser();
    getTimeline();
    getFollowing();
  }


  getLine()async{
    QuerySnapshot snapshot = await timeline
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });

  }

  getFollewers(){

  }


  getTimeline() async{
    getFollowing();
    print("list");
    print(followingList);
    /*print("GETTIMELINE");
    QuerySnapshot snapshot = await timelineRef
      .doc(currentUserId)
      .collection('timelinePosts')
      .orderBy('timestamp', descending: true)
      .get();
    List<Post> posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    print("POSTS");
    print(posts);
    setState(() {
      this.posts = posts;
      print("length5555555");
      print(posts.length);
    });0*/

    QuerySnapshot snapshot = await timeline
        .orderBy('timestamp', descending: true)
        .get();


    List<Post> posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();

    for(var i = 0; i < posts.length; i++){
      if(followingList.contains(posts[i].ownerId) == false){
        posts.removeAt(i);
        i = i -1 ;
      }
    }

    setState(() {
      this.posts = posts;
    });

  }

  getFollowing()async{
    QuerySnapshot snapshot = await followingRef
      .doc(currentUserId)
      .collection('userFollowing')
      .get();
    if (this.mounted) {
      setState(() {
        followingList = snapshot.docs.map((doc) => doc.id).toList();
      });
    }
  }



  getUser() async{
    //final String? id = currentUserId;
    final DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
    setState(() {
      namee = doc["userName"];
      uid = currentUserId;

    });
    return namee;

  }

  buildTimeline() {
    if(posts == null){
      return circularProgress();
    }else if(posts.isEmpty){
      //return buildUsersToFollow();
      //return Text("Opss! Hiç fotoğraf yok!", style: TextStyle(fontFamily: 'Mukta', fontSize: 30),);
      return circularProgress();
    } else {
      return ListView(children: posts);
    }

  }

  buildUsersToFollow(){
    return StreamBuilder(
      //stream: usersRef.orderBy('timestamp', descending: true).limit(1)
        stream: usersRef.limit(30)
      .snapshots(),
      builder: (context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        List<UserResult> userResults = [];

        snapshot.data.docs.forEach((doc){
          User user = User.fromDocument(doc);
          final bool isAuthUser = currentUserId == user.id;
          final bool isFollowingUser = followingList.contains(user.id);

          if(isAuthUser){
            return Text("okkk");
          }else if(isFollowingUser){
            return Text("bye");
          } else{
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }

        });
        return Container(

            color: Theme.of(context).accentColor.withOpacity(0.2),
            child: Column(
              children: <Widget> [
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.person_add,
                        color: Theme.of(context).primaryColor,
                        size: 30.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "Users to Follow",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(children: userResults),
              ],
            )

        );


      }
    );
  }

  @override
  Widget build(context) {
    getFollowing();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Timeline', style: GoogleFonts.mochiyPopPOne()),
        backgroundColor: Colors.lightGreen.shade400,
        actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.person_add_alt_1 ,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Suggestfriends()));
          },
        ),
          IconButton(
            icon: Icon(
              Icons.logout ,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Start()));
            },
          )
      ],



    ),

      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeline(),
      )
    );
  }
}