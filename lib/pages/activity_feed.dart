import 'package:flutter/material.dart';
import 'package:baby/pages/post_screen.dart';
import 'package:baby/pages/profile.dart';
import 'package:baby/pages/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

import 'header.dart';
import 'home.dart' as home;


class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {


  getActivityFeed() async{
    print("ACFEED");
    QuerySnapshot snapshot = await home.activityFeedRef
        .doc(home.currentUserId)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    List<ActivityFeedItem> feedItems = [];

    //print(snapshot.size);
    //print(snapshot.docs[5].get('username'));
    //feedItems.add(ActivityFeedItem.fromDocument(snapshot.docs[0]));
    //feedItems.add(ActivityFeedItem.fromDocument(snapshot.docs[1]));

    //List<ActivityFeedItem> feedItems = [];
    setState(() {
      print("ok");
      snapshot.docs.forEach((doc) {
        feedItems.add(ActivityFeedItem.fromDocument(doc));
      });
    });
    print("items");
    print(feedItems);


    /*snapshot.docs.forEach((doc) {
      print('Activity Feed Item: ${doc.data}');
    });*/
    return feedItems;
  }
  @override
  Widget build(BuildContext context) {
    print("HERERHERHERHE");
    return Scaffold(
      backgroundColor: Colors.yellow.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Bildirimler', style: GoogleFonts.mochiyPopPOne()),
        backgroundColor: Colors.yellow.shade700,

      ),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context,  AsyncSnapshot snapshot){
            if(!snapshot.hasData){
             // print(getActivityFeed().length);
              return circularProgress();
             // return Text("No Items");
            }
            return
                ListView(
                  children: snapshot.data,
                );
          },
        )
      ),
    );
  }
}

Widget? mediaPreview;
String activityItemText = "";

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // like, follow, comment
  final String mediaUrl;
  final String postId;
  //final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem({
    required this.username,
    required this.userId,
    required this.type,
    required this.mediaUrl,
    required this.postId,
    //required this.userProfileImg,
    required this.commentData,
    required this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc){
    print("girdi11111111111");
    return ActivityFeedItem(

        username: doc['username'],
        userId: doc['userId'],
        type: doc['type'],
        mediaUrl: doc['mediaUrl'],
        postId: doc['postId'],
      //  userProfileImg: doc['userProfileImg'],
        commentData: doc['commentData'],
        timestamp: doc['timestamp'],
    );
  }

  showPost(context){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostScreen(
              userId: userId,
              postId: postId
          )
      ),
    );
  }

    configureMediaPreview(context){
      if(type == 'like' ||type == 'comment' ){
        mediaPreview = GestureDetector(
          onTap: () => showPost(context),
          child: Container(
            height: 50.0,
            width: 50.0,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaUrl),
                  )
                )
              )
            )
          )
        );
      }else {
        mediaPreview = Text('');
      }

      if(type == 'like'){
        activityItemText = " gönderini beğendi.";
      } else if(type == 'follow'){
        activityItemText = " seni takip etti";
      } else if(type == 'comment'){
        activityItemText = ' cevapladı: $commentData';
      } else {
        activityItemText = "Error: Unknown type '$type'";
      }
    }




  @override
  Widget build(BuildContext context){
    configureMediaPreview(context);
    print("fffff");
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          color: Colors.white54,
          child: ListTile(
            title: GestureDetector(
              onTap: () => showProfile(context, profileId: userId),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$activityItemText',
                    ),
                  ]
                ),

              ),
            ),
            /*leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfileImg),
            ),*/
            subtitle: Text(
              timeago.format(timestamp.toDate()),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: mediaPreview,
          ),
        ),
    );
  }
}

showProfile(BuildContext context, { required String profileId}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) =>
  Profile(profileId: profileId)));
}