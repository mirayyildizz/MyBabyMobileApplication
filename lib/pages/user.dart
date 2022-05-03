import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  late final String id;
  late final String userName;
  late final String babyName;
  late final String email;
  late final String babyWeight;
  late final String babyHeight;
  late final String birthday;

  User({
    required this.id,
    required this.userName,
    required this.babyName,
    required this.email,
    required this.babyWeight,
    required this.babyHeight,
    required this.birthday,

});
    factory User.fromDocument(DocumentSnapshot doc){
      return User(
        id: doc['id'],
        userName: doc['userName'],
        babyName: doc['babyName'],
        email: doc['email'],
        babyWeight: doc['babyhWeight'],
        babyHeight: doc['babyHeight'],
        birthday: doc['birthday']
      );
    }
}