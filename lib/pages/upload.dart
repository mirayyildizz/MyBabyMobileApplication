
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:baby/pages/progress.dart';
import 'package:baby/pages/timeline.dart';
import 'package:baby/pages/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart' as aut;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';



import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:baby/pages/user.dart' as u;


import 'home.dart';

String namee = "";

class Upload extends StatefulWidget {
  late final aut.User? currentUser = aut.FirebaseAuth.instance.currentUser;

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  late final aut.User? currentUser = aut.FirebaseAuth.instance.currentUser;
  File? file;
  late String namee = "";
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  final imagePicker = ImagePicker();
  bool isUploading = false;
  String postId = Uuid().v4();


  Future handleTakePhoto() async {
    Navigator.pop(context);
    final image = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 675,
        maxWidth: 960);
    setState(() {
      file = File(image!.path);
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    final image = await ImagePicker().getImage(
        source: ImageSource.gallery);
    setState(() {
      file = File(image!.path);
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Gönderi Yarat"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Kamera ile fotoğraf çek"),
                onPressed: handleTakePhoto,

              ),
              SimpleDialogOption(
                child: Text("Galeriden fotoğraf seç"),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Vazgeç"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        }
    );
  }

  Container buildSplashScreen() {
    return Container(

        color: Colors.blue.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/ZanMzK01.svg', height: 260.0),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text("Fotoğraf Paylaş", style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                  ),
                  color: Colors.blueAccent,
                  onPressed: () => selectImage(context)
              ),
            ),
          ],
        )
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(file!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile)async {
    UploadTask uploadTask = storageRef.child("post_$postId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask; //oncomplete
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore({required String mediaUrl, required String location, required String description}){
    postsRef
      .doc(widget.currentUser!.uid)
      .collection("usersPosts")
      .doc(postId)
      .set({
        "postId" : postId,
        "ownerId" : widget.currentUser!.uid,
        "userName" : namee, // burada hata çıkabilir
        "mediaUrl" : mediaUrl,
        "description" : description,
        "location" : location,
        "timestamp": DateTime.now().toString(),
        "likes" : {},

    });

    timeline
        .doc(postId)
        .set({
      "postId" : postId,
      "ownerId" : widget.currentUser!.uid,
      "userName" : namee, // burada hata çıkabilir
      "mediaUrl" : mediaUrl,
      "description" : description,
      "location" : location,
      "timestamp": DateTime.now().toString(),
      "likes" : {},

    });


  }



  handleSubmit()async {
    print("geldiii");
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  getUser() async{
    //final String? id = currentUserId;
    final DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
    print(doc.data());
    print(doc.exists);
    if (this.mounted) {
      setState(() {
        namee = doc["userName"];
      });
    }
    print("curerent USER ID");
    print(currentUserId);
    return namee;

  }

  Scaffold buildUploadForm() {
    print("İÇERDE");
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white70,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage,
          ),
          title: Text(
            "Bir Yorum Ekle",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            FlatButton(

              //onPressed: () => isUploading ? null : () => handleSubmit(),
              onPressed: () => handleSubmit(),
              child: Text(
                "Paylaş",
                style: TextStyle(color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                ),
              ),
            ),
          ],
        ),
        body: ListView(
            children: <Widget>[
              isUploading ? linearProgress() : Text(""),
              Container(
                height: 220.0,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (FileImage(file!)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              ListTile(
                /*leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),*/
                title: Container(
                  width: 250.0,
                  child: TextField(
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: "Bir şeyler yaz..",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.pin_drop, color: Colors.orange, size: 35.0),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      hintText: "Fotoğraf Nerede Çekildi?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                width: 200.0,
                height: 100.0,
                alignment: Alignment.center,
                child: RaisedButton.icon(
                  label: Text("Şu Anki Konumunu Kullan",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue,
                  onPressed: () => print("coordinates"),
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ),
            ]
        )

    );
  }

  /*getUserLocation() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy:
    LocationAccuracy.high);
    List<Placemark> placemarks =  await Geolocator.p
    Placemark placemark = placemarks[0];
  }*/

  @override
  Widget build(BuildContext context) {
    getUser();
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}