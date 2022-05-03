import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final usersRef = FirebaseFirestore.instance.collection('user');
String curent = "";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Sign In function
  Future<User?> signIn(String email, String password, BuildContext context) async {
    var user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
          String curent = user.user.uid;
          getCurrentUserId(curent);
      //currentUser = user.user;
    }catch(e){
      error(context, e);
    }
    return user.user;
  }

  //Sign Out
  signOut() async {

    return await _auth.signOut();
  }

  //Register
  Future<User?> createPerson(String name, String email, String password, String babyweight,
      String babyname, String babyheight, String context, String time) async {

    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    try{
    await _firestore
        .collection("users")
        .doc(user.user!.uid)
        .set({'id': user.user!.uid, 'userName': name, 'email': email, 'babyName' : babyname, 'babyHeight' : babyheight, 'babyhWeight' : babyweight, 'birthday' : time});
    } catch(e){
      error(context, e);
    }
    return user.user;
  }

  error(context, e){

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Error"),
        content : Text(e.toString())
     );


    });

  }

  Future<String> getCurrentUID() async{
    return (await _auth.currentUser!).uid;
  }

  Future getCurrentUser(String curent) async{

    return await  _auth.currentUser;
  }

  String getCurrentUserId(String a){
    return a;
  }


}

