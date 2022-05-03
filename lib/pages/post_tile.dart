import 'package:flutter/material.dart';
import 'package:baby/pages/custom_image.dart';
import 'package:baby/pages/post.dart';
import 'package:baby/pages/post_screen.dart';



class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  showPost(context){

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostScreen(
              userId: post.ownerId,
              postId: post.postId
          )
      ),
    );
  }




  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => showPost(context),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }

}