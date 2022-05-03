import 'package:baby/pages/disease.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baby/pages/progress.dart';
import 'package:baby/pages/search.dart';
import 'package:baby/pages/timeline.dart';
import 'package:baby/pages/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'as u;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class Suggestfriends extends StatefulWidget {

  @override
  _Suggestfriends createState() => _Suggestfriends();
}



class _Suggestfriends extends State<Suggestfriends> {
  List<String> followingList = [];
  int numeofD = 0;
  int numeofD2 = 0;




  getFollowing()async{
    QuerySnapshot snapshot = await followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
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
          List<UserResult> others = [];
          int counter = 0;

          u.FirebaseAuth auth = u.FirebaseAuth.instance;
          bool ok = false;
          u.User? user2 = auth.currentUser;
          String id = user2!.uid;


          snapshot.data.docs.forEach((doc) async {
            User user = User.fromDocument(doc);


            if(counter < 2){
              final bool isAuthUser = currentUserId == user.id;
              final bool isFollowingUser = followingList.contains(user.id);

              if (isAuthUser) {
                return Text("okkk");
              } else if (isFollowingUser) {
                return Text("bye");
              } else {
                UserResult userResult = UserResult(user);
                userResults.add(userResult);
                counter++;
              }
              print(counter);

            }

            if(counter >= 2 && counter < 4){
              print("girdiiiii");
              final bool isAuthUser = currentUserId == user.id;
              final bool isFollowingUser = followingList.contains(user.id);

              if (isAuthUser) {
                return Text("okkk");
              } else if (isFollowingUser) {
                return Text("bye");
              } else {
                UserResult userResult = UserResult(user);
                others.add(userResult);
                counter++;
              }
              print(counter);
             /* DocumentSnapshot doc2 = await usersRef.doc(user.id).get();
              Disease dis = Disease.fromDocument(doc2);
              numeofD = dis.counter;
              print("num1");
              print(numeofD);

              DocumentSnapshot doc3 = await usersRef.doc(id).get();
              Disease dis2 = Disease.fromDocument(doc3);
              numeofD2 = dis2.counter;
              print("num2");
              print(numeofD2);

              if(numeofD == numeofD2){
                UserResult userResult = UserResult(user);
                others.add(userResult);
                counter ++;
              }
              print("others");
              print(others);*/


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
                          "Bu Kişileri Takip Edebilirsin!",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(children: userResults),
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
                          "Bagışıklıga Göre",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(children: others),
                ],
              )

          );


        }
    );
  }




  @override
  Widget build(BuildContext context) {
    getFollowing();
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Önerilenler', style: TextStyle(fontFamily: 'MochiyPopPOne')),
        backgroundColor: Colors.yellowAccent.shade700,

      ),
      body: ListView(
        children: <Widget> [

          buildUsersToFollow(),
        ],
      ),
    );
  }
}

