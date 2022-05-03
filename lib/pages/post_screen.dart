import 'package:flutter/material.dart';
import 'package:baby/pages/home.dart';
import 'package:baby/pages/post.dart';
import 'package:baby/pages/progress.dart';


import 'header.dart';

class PostScreen extends StatelessWidget {

  final String userId;
  final String postId;

  PostScreen({required this.userId, required this.postId});

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: postsRef.doc(userId).collection('usersPosts').doc(postId).get(),
      builder: (context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(context, titleText: post.description ),
            body: ListView(
              children: <Widget>[
                Container(
                  child:post,
                )
              ]
            )
          )
        );
      }
    );
  }
}