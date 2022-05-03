
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby/pages/progress.dart';
import 'package:baby/pages/timeline.dart';
import 'package:baby/pages/user.dart' as u;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:baby/pages/register.dart';

import 'Start.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({required this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController babyWeight = TextEditingController();
  TextEditingController babyHeight = TextEditingController();
  TextEditingController birthday = TextEditingController();

  bool isLoading = false;
  late u.User user;
  bool _bioValid = true;
  bool _displayNameValid = true;

  @override
  void initState(){
    super.initState();
    getUser();
  }

  getUser()async{
    setState((){
      isLoading = true;
    });
      DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
      user = u.User.fromDocument(doc);
      displayNameController.text = user.userName;
    bioController.text = user.babyName;
    babyWeight.text = user.babyWeight;
    babyHeight.text = user.babyHeight;
    birthday.text = user.birthday;
    setState((){
      isLoading = false;
    });
  }

  Column buildDisplayNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Anne ismi",
          style: GoogleFonts.mochiyPopPOne(color: Colors.grey)
          )
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Kullanıcı ismini güncelle",
            errorText: _displayNameValid ? null : "Girilen isim çok kısa",
          ),
        ),
      ],
    );
  }


  Column buildWeightField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text("Bebegin kilosu",
                style: GoogleFonts.mochiyPopPOne(color: Colors.grey)
            )
        ),
        TextField(
          controller: babyWeight,
          decoration: InputDecoration(
            hintText: "Kullanıcı kilosunu güncelle",
            //errorText: _displayNameValid ? null : "Girilen isim çok kısa",
          ),
        ),
      ],
    );
  }

  Column buildHeightField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text("Bebegin boyu",
                style: GoogleFonts.mochiyPopPOne(color: Colors.grey)
            )
        ),
        TextField(
          controller: babyHeight,
          decoration: InputDecoration(
            hintText: "Bebeğin boyunu güncelle",
            //errorText: _displayNameValid ? null : "Girilen isim çok kısa",
          ),
        ),
      ],
    );
  }

  Column buildBirthdayField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text("Dogum günü",
                style: GoogleFonts.mochiyPopPOne(color: Colors.grey)
            )
        ),
        TextField(
          controller: birthday,
          decoration: InputDecoration(
            hintText: "Doğum gününü güncelle ",
            //errorText: _displayNameValid ? null : "Girilen isim çok kısa",
          ),
        ),
      ],
    );
  }





  Column buildBioField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text("Bebek İsmi",
                style: GoogleFonts.mochiyPopPOne(color: Colors.grey)
            )
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Bebek İsmini güncelle",
            errorText: _bioValid ? null : "Girilen isim çok kısa",

          ),
        ),
      ],
    );
  }

  updateProfileData(){
    setState(() {
      displayNameController.text.trim().length < 3 ||
      displayNameController.text.isEmpty ? _displayNameValid = false :
      _displayNameValid = true;
      bioController.text.trim().length > 100 ? _bioValid = false :
          _bioValid = true;
    });

    if(_displayNameValid && _bioValid){
      usersRef.doc(widget.currentUserId).update({
        "userName": displayNameController.text,
        "babyName": bioController.text,
      });
      SnackBar snackbar = SnackBar(content: Text("Profil güncellendi!"));
      _scaffoldKey.currentState!.showSnackBar(snackbar);
    }

  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent.shade400,
        title: Text(
          "Profili Düzenle",
          style: GoogleFonts.mochiyPopPOne(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Start()));

            },
            icon: Icon(
              Icons.logout,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isLoading ?
          circularProgress() : ListView(
        children: <Widget> [
          Container(
            child: Column(
              children: <Widget> [
                /*Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0,),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: CachedNetworkImageProvider("https://console.firebase.google.com/project/mybabyapplication-d536c/storage/mybabyapplication-d536c.appspot.com/files/~2Fprofilresimleri~2FqpDdPwhVNROVes9O1x1EUkyNr243"),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDisplayNameField(),
                      buildBioField(),
                      buildWeightField(),
                      buildHeightField(),
                      buildBirthdayField(),

                    ],

                  ),
                ),
                RaisedButton(
                  onPressed: updateProfileData,
                  color: Colors.white,
                  child: Text(
                    "Güncelle",
                    style: GoogleFonts.mochiyPopPOne(
                      color: Colors.purple,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
               /* Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Start()));

                    },
                    icon: Icon(Icons.cancel, color: Colors.deepPurpleAccent.shade700),
                    label: Text("Çıkış Yap",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent, fontSize: 20.0, fontFamily: 'MochiyPopPOne'
                    ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}