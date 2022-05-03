import 'package:baby/pages/yazilar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baby/pages/home.dart';
import 'package:baby/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';


final AuthService _auth = AuthService();

class Blog extends StatefulWidget {
  @override
  _YaziEkraniState createState() => _YaziEkraniState();
}

class _YaziEkraniState extends State<Blog> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  String namee = "";

  TextEditingController gelenYaziBasligi = new TextEditingController();
  TextEditingController gelenYaziIcerigi = new TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;


  getUser() async{
    FirebaseFirestore.instance.collection("users").doc(currentUserId).get().then((gelenVeri) {
    setState(() {
    namee = gelenVeri.data()!['userName'];
    //gelenYaziIcerigi = gelenVeri.data()!['icerik'];
    });
    });

  }


  yaziEkle() {
    getUser();
    FirebaseFirestore.instance.collection("Yazilar").doc(t1.text).set({
      'kullaniciid': auth.currentUser!.uid,
      'kullaniciadi' : namee,
      'baslik': t1.text,
      'icerik': t2.text
    }).whenComplete(() => print("Yazı eklendi"));
    gelenYaziBasligi.clear();
    gelenYaziIcerigi.clear();

     Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Yazi()));


  }


  yaziGuncelle() {
    getUser();
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .update({'baslik': t1.text, 'icerik': t2.text}).whenComplete(
            () => print("Yazı güncellendi"));
  }

  yaziSil() {
    FirebaseFirestore.instance.collection("Yazilar").doc(t1.text).delete();
  }

  yaziGetir() {
    getUser();
    print("MİROSKO");
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()!['baslik'];
        gelenYaziIcerigi = gelenVeri.data()!['icerik'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getUser();

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigoAccent,
        title: Text("Blog yazısı ekle", style: GoogleFonts.mochiyPopPOne(color:Colors.white )),



      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: Center(
          child: Column(

            children: [
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.title),
                  hintText: 'Blog yazında nelerden bahsediyorsun?',
                  labelText: 'Başlık',
                ),
                controller: t1,
              ),
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.text_snippet_sharp),
                  hintText: 'Bir şeyler yaz...',
                  labelText: 'Metin',
                ),
                controller: t2,
              ),

              Row(
                children: [
                  RaisedButton(
                      color: Colors.indigoAccent,

                      child: Text("Ekle", style: TextStyle(color: Colors.white),),
                      onPressed: yaziEkle
                  ),

                ],
              ),

              ListTile(
                title: Text(gelenYaziBasligi.text),
                subtitle: Text(gelenYaziIcerigi.text),

              ),


            ],
          ),

        ),
      ),

    );

  }
}