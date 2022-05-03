import 'package:flutter/material.dart';
import 'package:baby/pages/home.dart';
import 'package:baby/pages/progress.dart';
import 'package:baby/pages/timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

String namee = "";
//String userId = "";


class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;


  Comments({
    required this.postId,
    required this.postOwnerId,
    required this.postMediaUrl,
  });
  @override
  CommentsState createState() => CommentsState(
    postId: this.postId,
    postOwnerId: this.postOwnerId,
    postMediaUrl: this.postMediaUrl,
  );
}

class CommentsState extends State<Comments>{
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;


  CommentsState({
    required this.postId,
    required this.postOwnerId,
    required this.postMediaUrl,
  });

  buildComments(){
    return StreamBuilder(
        stream: commentsRef
            .doc(postId)
            .collection('comments')
            .orderBy( 'timestamp' , descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData ){
            return circularProgress();
          }
          List<Comment> comments = [];


          snapshot.data.docs.forEach((doc){
            comments.add(Comment.fromDocument(doc));

          });

          return ListView(
            children: comments,
          );
        });

  }

  getUser() async{
    //final String? id = currentUserId;
    final DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
    print(doc.data());
    print(doc.exists);
    setState(() {
      namee = doc["userName"];

    });

    return namee;

  }

  addComment(){
    getUser();
    commentsRef
      .doc(postId)
      .collection("comments")
      .add({
        "username": namee,
        "comment" : commentController.text,
        "timestamp": DateTime.now(),
       // "avatarUrl" : "photo",
        "userId" : currentUserId,
    });

    bool isNotPostOwner = postOwnerId != user?.uid;
    if(isNotPostOwner) {
      activityFeedRef
          .doc(postOwnerId)
          .collection('feedItems')
          .add({
        "type": "comment",
        "commentData": commentController.text,
        "username": namee,
        "userId": user?.uid,
        //"userProfileImg" :
        "postId": postId,
        "mediaUrl": postMediaUrl,
        "timestamp": DateTime.now(),
      });
   }
    commentController.clear();
  }

  @override
  Widget build(BuildContext context){
    getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments', style: GoogleFonts.mochiyPopPOne()),
        backgroundColor: Colors.grey.shade600,

      ),
      body: Column(

        children: <Widget> [
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Bir yorum yaz...", labelStyle: TextStyle(color: Colors.indigoAccent)),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              color: Colors.red,
              child: Text("Paylaş", style: GoogleFonts.mochiyPopPOne()),
            )
          ),

        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  late final String userName;
  late final String userId;
 // late final String avatarUrl;
  late final String comment;
  late final Timestamp timestamp;

  Comment({
    required this.userName,
    required this.userId,
   // required this.avatarUrl,
    required this.comment,
    required this.timestamp,
  });

  factory Comment.fromDocument ( DocumentSnapshot doc){
    return Comment(
      userName: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
     // avatarUrl: doc['avatarUrl'],

    );
  }


  @override
  Widget build(BuildContext context){

    return Column(

      children: <Widget>[

        ListTile(
          //title: Text(comment),

          title: Text(userName, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: Colors.indigo.shade700),),
          /*leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),*/
         // subtitle : Text(timeago.format(timestamp.toDate())),
          subtitle: Text(comment + "\n\n" + timeago.format(timestamp.toDate()) + "\n\n"),
        ),
       // Divider(),
      ]
    );
  }
}