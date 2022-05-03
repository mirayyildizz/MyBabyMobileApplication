import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baby/pages/post_tile.dart';
import 'package:baby/pages/progress.dart';
import 'package:baby/pages/timeline.dart';
import 'package:baby/pages/user.dart' as u;
import 'Start.dart';
import 'edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:baby/pages/post.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:baby/pages/suggestFriends.dart';
import 'home.dart';
//final String currentUserId = auth.currentUser!.uid;

String namee = "";


class Profile extends StatefulWidget {
  late final String profileId;
  Profile({required this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}
FirebaseAuth auth = FirebaseAuth.instance;




class _ProfileState extends State<Profile>
{



  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  final postsRef =  FirebaseFirestore.instance.collection('posts');
  List<Post> posts = [];
  final String currentUserId = auth.currentUser!.uid;
  int followerCount = 0;
  int followingCount = 0;
  String postOrientation = "grid";

  @override
  void initState(){
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  getFollowers() async{
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();
    if(mounted) {
      setState(() {
        followerCount = snapshot.docs.length;
      });
    }
  }

  getFollowing() async{
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  checkIfFollowing() async{
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    if(mounted) {
      setState(() {
        isFollowing = doc.exists;
      });
    }
  }

  getProfilePosts() async{
    print("girdi");
    setState((){
      isLoading = true;
    });
   // print(widget.profileId);
    QuerySnapshot snapshot = await postsRef
      .doc(widget.profileId)
      .collection('usersPosts')
      .orderBy('timestamp', descending: true)
      .get();

    if(mounted) {
      setState(() {
        isLoading = false;
        postCount = snapshot.docs.length;
        //print(postCount);
        posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
      });
    }
  }

  getUser() async{
    //final String? id = currentUserId;
    final DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
   // print(doc.data());
   // print(doc.exists);
    if (this.mounted) {
      setState(() {
        namee = doc["userName"];
      });
    }
    return namee;

  }

  Column buildCountColumn(String label, int count){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight:  FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Container buildButton({required String text, required VoidCallback function}){
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: GoogleFonts.mochiyPopPOne(
              color: isFollowing ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Colors.pinkAccent.shade400,
            border: Border.all(
              color: isFollowing ? Colors.grey : Colors.pinkAccent.shade400,
            ),
            borderRadius:  BorderRadius.circular(5.0),
          )
        )
      )
    );
  }

  editProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
    EditProfile(currentUserId: currentUserId)));
  }


  buildProfileButton(){
    //return Text("profile button");
    bool isProfileOwner = currentUserId == widget.profileId;
    if(isProfileOwner){
      return buildButton(
        text: "Profili Düzenle",
        function: editProfile,
      );
    } else if(isFollowing){
      return buildButton(
        text: "Takipten Çık",
        function: handleUnfollowUser,
      );
    } else if(!isFollowing){
      return buildButton(
        text: "Takip Et",
        function: handleFollowUser,
      );
    }
  }







  handleUnfollowUser(){
    setState((){
      isFollowing = false;
    });
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get().then((doc) {
          if(doc.exists){
            doc.reference.delete();
          }
    });

    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
      });

    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .get()
        .then((doc){
          if(doc.exists){
            doc.reference.delete();
          }
    });

  }

  handleFollowUser(){
    setState((){
      isFollowing = true;
    });
    followersRef
    .doc(widget.profileId)
    .collection('userFollowers')
    .doc(currentUserId)
    .set({});

    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});

    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
    .set({
      "type" : "follow",
      "ownerId" : widget.profileId,
      "username" : namee,
      "userId" : currentUserId,
      //"userProfileImg" :
      "timestamp" : DateTime.now(),
      "commentData" : "",
      "mediaUrl": "",
      "postId" : "",
    });

  }

  buildProfileHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profileId).get(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        u.User user = u.User.fromDocument(snapshot.data!);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  /*CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:CachedNetworkImageProvider(user.profileIm),
                  ),*/
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn("gönderiler", postCount),
                            buildCountColumn("takipçiler", followerCount),
                            buildCountColumn("takip edilenler", followingCount),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding : EdgeInsets.only(top: 12.0),
                child: Text(
                  user.userName,
                  style: TextStyle(
                    fontWeight:  FontWeight.bold,
                    fontSize: 16.0
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding : EdgeInsets.only(top: 4.0),
                child: Text(
                  user.babyName,
                  style: TextStyle(
                      fontWeight:  FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding : EdgeInsets.only(top: 2.0),
                child: Text(
                  user.email,
                ),
              ),
            ],
          )
        );
      }
    );
  }

  buildProfilePosts(){
    if(isLoading){
      return circularProgress();
    } else if(posts.isEmpty){
      return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset('assets/images/resimyok.svg', height: 260.0),

              /*Padding(
                padding: EdgeInsets.only(top: 15.0),
                child:
                    Text("No Posts", style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    ),

                ),*/

            ],
          )
      )
      ; } else if(postOrientation == "grid"){
      // return Column(children: posts,);
      List<GridTile> gridTiles = [];
      posts.forEach((post){
        gridTiles.add(GridTile(child: PostTile(post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,

      );
    } else if(postOrientation == "list"){
        return Column(
          children: posts,
        );
    }

  }

  setPostOrientation(String postOrientation){
    setState(() {
      this.postOrientation = postOrientation;
    });
  }


  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid' ? Colors.pinkAccent.shade400 : Colors.grey,
        ),

        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == 'list' ? Colors.pinkAccent.shade400 : Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    getUser();

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil', style: GoogleFonts.mochiyPopPOne()),
        backgroundColor: Colors.pinkAccent.shade400,
        actions: <Widget>[
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
      body: ListView(
        children: <Widget> [
        buildProfileHeader(),
          Divider(),
          buildTogglePostOrientation(),
          Divider(
            height: 0.0,
          ),
          buildProfilePosts(),
        ],
      ),
    );
  }
}