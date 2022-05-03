import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby/pages/custom_image.dart';
import 'package:baby/pages/progress.dart';
import 'package:baby/pages/timeline.dart';
import 'package:baby/pages/user.dart' as u;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:baby/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'comments.dart';

String namee = "";
String userId = "";
String userProfileImage = "";



class Post extends StatefulWidget {
  late final String postId;
  late final String ownerId;
  late final String userName;
  late final String location;
  late final String description;
  late final String mediaUrl;
  late final String timestamp;
  late final dynamic likes;






  Post({
    required this.postId,
    required this.ownerId,
    required this.userName,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.timestamp,
    this.likes,



  });

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      userName: doc['userName'],
      location: doc['location'],
      timestamp: doc['timestamp'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],


    );
  }

  int getLikeCount(likes){
    if(likes == null){
      return 0;
    }
    int count = 0;
    likes.values.forEach((val){
      if(val == true){
        count+=1;
      }
    });
    return count;
  }



  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    userName: this.userName,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    timestamp : this.timestamp,
    likes: this.likes,
    likeCount: getLikeCount(this.likes),

  );
}



class _PostState extends State<Post>{

  late final String postId;
  late final String ownerId;
  late final String userName;
  late final String location;
  late final String description;
  late final String mediaUrl;
  late final String timestamp;
  int likeCount;
  Map likes;
  late  bool isLiked;
  late bool showHearth = false;



  _PostState({
    required this.postId,
    required this.ownerId,
    required this.userName,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.likeCount,
    required this.likes,
    required this.timestamp,


  });




  buildPostHeader(){
    return FutureBuilder<DocumentSnapshot>(

      future: usersRef.doc(ownerId).get(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return circularProgress();
          }
          u.User user = u.User.fromDocument(snapshot.data!);
          bool isPostOwner = currentUserId == ownerId;
          return ListTile(
            /*leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider("https://console.firebase.google.com/project/mybabyapplication-d536c/storage/mybabyapplication-d536c.appspot.com/files/~2Fprofilresimleri~2FqpDdPwhVNROVes9O1x1EUkyNr243"),
              backgroundColor: Colors.grey,
            ),*/
            title: GestureDetector(
              onTap: () => print('showing profile'),
              child: Text(
                user.userName,
                style:GoogleFonts.dmSerifDisplay(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                ),
              ),
            ),
            trailing: isPostOwner ? IconButton(
              onPressed: () => handleDeletePost(context),
              icon: Icon(Icons.more_vert),
            ) : Text(''),
          );
      },
    );
    
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        //barrierColor: Colors.pink.shade100,
        context: parentContext,
        builder: (context) {
          return SimpleDialog(title: Text("Fotoğrafı silmek istiyor musunuz?", style: GoogleFonts.permanentMarker(),),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: (){
                  Navigator.pop(context);
                  deletePost();
                },
                child: Text('Sil',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed : () => Navigator.pop(context),
                child: Text('Vazgeç')
              ),
            ],

          );
        }
    );
  }

  // postu silmek için currentUserId ve ownerId aynı olmalı. çünkü sadece kullanıcı kendi postunu silebilir.
  deletePost() async{
    postsRef
        .doc(ownerId)
        .collection('usersPosts')
        .doc(postId)
        .get().then((doc){
          if(doc.exists){
            doc.reference.delete();
          }
      });

    storageRef.child("post_$postId.jpg").delete();

    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .doc(ownerId)
        .collection('feedItems')
        .where('postId', isEqualTo: postId)
        .get();

    activityFeedSnapshot.docs.forEach((doc) {
      if(doc.exists){
        doc.reference.delete();
      }
    });

    QuerySnapshot commentsSnapshot = await commentsRef
      .doc(postId)
      .collection('comments')
      .get();
    commentsSnapshot.docs.forEach((doc) {
      if(doc.exists){
        doc.reference.delete();
      }
    });
  }


  handleLikePost(){
    bool _isLiked = likes[currentUserId] == true;

    if(_isLiked){
      postsRef
      .doc(ownerId)
      .collection('usersPosts')
      .doc(postId)
      .update({'likes.$currentUserId' : false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });

      timeline
      .doc(postId)
          .update({'likes.$currentUserId' : false});


    } else if(!_isLiked){
      postsRef
          .doc(ownerId)
          .collection('usersPosts')
          .doc(postId)
          .update({'likes.$currentUserId' : true});
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHearth = true;
      });

      timeline
          .doc(postId)
          .update({'likes.$currentUserId' : true});


      Timer(Duration(milliseconds: 500), (){
        setState(() {
          showHearth = false;
        });
      });
    }





  }

  getUser() async{
    //final String? id = auth.currentUser!.uid;
    final DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
    setState(() {
      namee = doc["userName"];
      userId = doc["id"];

      //userProfileImage = doc[""]
    });

    return namee;

  }

  addLikeToActivityFeed(){
    bool isNotPostOwner = currentUserId != ownerId;
    //if(isNotPostOwner) {
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .set({
        "type": "like",
        "username": namee,
        "userId": userId,
        //"userProfileImg" :
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": DateTime.now(),
        "commentData" : "",
      });
    //}

  }

  removeLikeFromActivityFeed(){
    bool isNotPostOwner = currentUserId != ownerId;
    if(isNotPostOwner) {
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      }
      );
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //Image.network(mediaUrl),
          cachedNetworkImage(mediaUrl),
         /*showHearth ? Animator(
           duration: Duration(milliseconds: 300),
           tween: Tween(begin: 0.8, end: 1.4),
           curve: Curves.elasticOut,
           cycles: 0,
           builder: (anim) => Transform.scale(
             scale: anim.value,
               child: Icon(
                 Icons.favorite,
                 size: 80.0,
                 color: Colors.red,)
           ),
         ) : Text(""),*/
          showHearth ? Icon(Icons.favorite, size: 80.0,
              color: Colors.red,)
              : Text(""),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: handleLikePost,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
               // Icons.favorite,
                size: 28.0,
                color: Colors.pink,

              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl,


              ),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],

              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: GoogleFonts.mukta(color: Colors.black,
                fontSize: 15,

                    ),
              ),
            ),
          ],
        ),
       /* Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$userName",
                style: TextStyle(color: Colors.black,
                  fontWeight: FontWeight.bold,),
              ),
            ),
            Expanded(child: Text(description))
          ],
        )*/
      ],
    );
  }

  @override
  Widget build(BuildContext context){

    getUser();

    isLiked = (likes[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget> [
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}

showComments(BuildContext context, {required String postId, required String ownerId, required String mediaUrl}){
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}
