import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blog.dart';
import 'home.dart';

class Yazi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Blog Yazıları', style: GoogleFonts.mochiyPopPOne()),
        backgroundColor: Colors.lightGreenAccent.shade400,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.post_add_rounded ,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Blog()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.home ,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home()));
            },
          )
        ],


      ),
      body: TumYazilar(),
    );
  }
}

class TumYazilar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
    FirebaseFirestore.instance.collection('Yazilar');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return new Card(
              color: Colors.lightGreen.shade50,
            child: ListTile(
              title: new Text(document['kullaniciadi'] + "\n" + document['baslik'], style: GoogleFonts.dmSerifDisplay( fontSize: 20),),
              subtitle: new Text(document['icerik'], style: GoogleFonts.dmSerifDisplay(fontStyle: FontStyle.italic, fontSize: 16 , color: Colors.black87),),


            ));

          }).toList(),
        );
      },
    );
  }
}