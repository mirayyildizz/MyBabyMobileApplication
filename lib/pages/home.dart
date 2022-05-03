import 'dart:developer';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baby/pages/babyInfo.dart';
import 'package:baby/pages/search.dart';
import 'package:baby/pages/timeline.dart';
import 'package:baby/pages/activity_feed.dart';
import 'package:baby/pages/upload.dart';
import 'package:baby/pages/profile.dart';
import 'package:baby/pages/yazilar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby/pages/user.dart' as u;
import 'package:kmeans/kmeans.dart';

import 'numofdiseases.dart';



final Reference storageRef = FirebaseStorage.instance.ref();
final postsRef = FirebaseFirestore.instance.collection('posts');
FirebaseAuth auth = FirebaseAuth.instance;
bool ok = false;
User? user = auth.currentUser;

String currentUserId = auth.currentUser!.uid;

final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');

final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final timeline = FirebaseFirestore.instance.collection('timelineRef');
final diseasRef = FirebaseFirestore.instance.collection('diseases');

final babyRef = FirebaseFirestore.instance.collection('babyHealth');


class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  bool isAuth = false;
  late PageController pageController = PageController();
  int pageIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;




  @override
  void initState(){
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
  buildAuthScreen(){
    return Text('Authenticated');
  }
  changes(){
     /* FirebaseAuth.instance
          .idTokenChanges()
          .listen((User? user) {
      if (user == null) {
      print('User is currently signed out!');
      } else {
      print('User is signed in!');
      }
      });*/

      FirebaseAuth auth = FirebaseAuth.instance;

      user = auth.currentUser;

      currentUserId = auth.currentUser!.uid;

  }


  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    changes();
    // FirebaseAuth auth = FirebaseAuth.instance;
    // var user = auth.currentUser;
    //var user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      body: PageView(
        children: <Widget> [
          Timeline(),
          ActivityFeed(),
          //Upload(currentUser: auth.currentUser),
          Upload(),
          Search(),
          Profile(profileId: auth.currentUser!.uid ),
          Yazi(),
          BabyInfoInf(),
          //Clustering(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,

        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items : [
          BottomNavigationBarItem(
            icon:
            Icon(
                Icons.whatshot,
                size: 45.0,
                color: Colors.green,

            ),
          ),
          BottomNavigationBarItem(
            icon:
            Icon(
                Icons.notifications_active,
                size : 45.0,
              color: Colors.yellow,
            ),
          ),
          BottomNavigationBarItem(
            icon:
            Icon(
              Icons.photo_camera,
              color: Colors.blueAccent,
              size: 45.0,
            ),
          ),
          BottomNavigationBarItem(
            icon:
            Icon(
                Icons.search,
                color: Colors.deepOrange,
                    size: 45.0
            ),
          ),
          BottomNavigationBarItem(
            icon:
            Icon(
                Icons.account_circle,
                size: 45.0,
              color: Colors.pink.shade600,
            ),
          ),
          BottomNavigationBarItem(
            icon:
            Icon(
              Icons.mode_sharp,
              size : 45.0,
              color: Colors.lightGreenAccent,
            ),
          ),
          BottomNavigationBarItem(
            icon:
            Icon(
              Icons.child_care_outlined,
              size : 45.0,
              color: Colors.purple,
            ),
          ),
         /* BottomNavigationBarItem(
            icon:
            Icon(
              Icons.three_p_sharp,
              size : 45.0,
              color: Colors.purple,
            ),
          ),*/

        ]
      ),
    );
  }
}