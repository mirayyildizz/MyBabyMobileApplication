import 'package:baby/pages/progress.dart';
import 'package:baby/pages/search.dart';
import 'package:baby/pages/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:baby/pages/timeline.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby/pages/user.dart' as u;
import 'package:kmeans/kmeans.dart';
import 'package:google_fonts/google_fonts.dart';

import 'disease.dart';
import 'home.dart';

import 'numofdiseases.dart';

//List allData = [];
List<NumOfDiseases>nums = [];
List<List<double>> list1 = [];
List numbers = [];
var i = 0;
late var ok;
bool control = false;

late KMeans newKmeans;
late var bestClusters;
bool control1 = false;
bool control2 = false;
bool control3 = true;

List<UserResult> others = [];
List suggestUs = [];

//KMeans newKmeans;


class Clustering extends StatefulWidget {


  @override
  _Clustering createState() => _Clustering();
}

class _Clustering extends State<Clustering> {
  List<String> followingList = [];







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
    //createlist();
  }


  buildUsersToFollow(){
    // clustering();
    //createlist();

    return StreamBuilder(
      //stream: usersRef.orderBy('timestamp', descending: true).limit(1)
        stream: usersRef.limit(30)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return circularProgress();
          }
          List<UserResult> userResults = [];

          int count = 0;

          snapshot.data.docs.forEach((doc){
            User user = User.fromDocument(doc);
            final bool isAuthUser = currentUserId == user.id;
            final bool isFollowingUser = followingList.contains(user.id);


            if(count < 3) {
              if (isAuthUser) {
                return Text("okkk");
              } else if (isFollowingUser) {
                return Text("bye");
              } else {
                UserResult userResult = UserResult(user);
                userResults.add(userResult);
              }

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
                          color: Colors.redAccent,
                          size: 25.0,
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          "Bu kişilere göz at!",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 25.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(children: userResults),
                  Column( children:  <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Colors.redAccent,
                      size: 30.0,
                    ),
                    SizedBox(width: 8.0,),
                    Text(
                      "Bağışıklığa göre öneriler ",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 25.0,
                      ),
                    ),
                  ],),
                  Column(children: others),

                ],
              )

          );


        }
    );
  }

  Widget sifirla() {
    followingList = [];
    numbers = [];
    //  users = [];
    //counter = 0;
    return Stack(
        children: <Widget>[
          /* Positioned(
              left: 90,
              child: Icon(Icons.home, color: Colors.black, size: 20,) ),*/
          Padding(
            padding: EdgeInsets.only(left: 110),
            child: Text( '' ),
          )
        ]
    );
  }


  /*diseases() async {
    print("ok");

    for(int i = 0; i < allData.length; i++) {
      print(allData[i]);
      DocumentSnapshot doc = await diseasRef.doc(allData[i]).get();
      if (mounted) {
        setState(() {
          print("LENGTH İS DİSEASES");
          numbers.add(doc.get('count'));
        });
      }
    }
  }*/


  hepsi() async {
   // print("control");
    // print(control);
  //  if(control == true) {
    QuerySnapshot snapshot = await diseasRef
        .doc(allData[i])
        .get();
    setState(() {
      ok = snapshot.docs.get('count');
    });


    if(mounted){
      setState(() async {


        // Get data from docs and convert map to List





        control = false;
      /*if(list1.length < allData.length) {
        for (var j = 0; j < allData.length; j++) {
          print("ok");
          print(nums[j].num);
          print(nums[j].id);
          list1.add([(nums[j].num).toDouble()]);
        }
      }

      print("NUMS length");
      print(list1.length);
      if(list1.length > 0 && control3 == true){
        control3 = false;
        newKmeans = KMeans(list1);
        print(newKmeans.points);
        print("LİST 1111");
        print(newKmeans);
        bestClusters = newKmeans.fit(2);
        print("clusters");
        print(bestClusters);
        print("poınts");
        print(bestClusters.points);
        print("OKKKKKKKKKKKKK");
        print(bestClusters.clusters[0]);
        print("ather");
        print(bestClusters.clusters);

        print("find indexes");
        print(allData.indexOf(currentUserId));
        int currentIndex = allData.indexOf(currentUserId);
        int currentCluster = bestClusters.clusters[currentIndex];

        for(var k = 0; k < allData.length; k++){
          if(bestClusters.clusters[k] == currentCluster){
            suggestUs.add(allData[k]);
          }

        }


        QuerySnapshot querySnapshot2 = await usersRef.get();

        // Get data from docs and convert map to List
        for(var z = 0; z < allData.length; z++){

          if(suggestUs.contains(querySnapshot2.docs[z].get('id'))){
            User user = User.fromDocument(querySnapshot2.docs[z]);
            UserResult userResult = UserResult(user);
            others.add(userResult);
          }
        }

        control = false;
      }*/
      }); }

    //}


  }


  @override
  void initState(){
    hepsi();
    //diseases();
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    print("BUİLDASD");
    print(numbers);
    //print(allData);
    //print("SUGGEEEEEEEEEST");
    //print(suggestUs);
    getFollowing();

    //print("OTHERS");
    //print(others);
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Arkadaş Öner', style: GoogleFonts.mochiyPopPOne()),
        backgroundColor: Colors.lightBlueAccent.shade400,

      ),
      body: ListView(
        children: <Widget> [

          buildUsersToFollow(),
          sifirla(),

        ],
      ),
    );
  }
}