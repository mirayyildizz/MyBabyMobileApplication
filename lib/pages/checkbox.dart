
import 'package:baby/pages/activity_feed.dart';
import 'package:baby/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:baby/pages/babyInfo.dart';
import 'package:baby/pages/profile.dart';
import 'home.dart';

class CheckBox extends StatefulWidget {
  @override _CheckBox createState() => _CheckBox();
}

class _CheckBox extends State<CheckBox> {
  bool hast1 = false;
  bool hast2 = false;
  bool hast3 = false;
  bool hast4 = false;
  bool hast5 = false;
  bool hast6 = false;
  bool hast7 = false;
  bool hast8 = false;
  int counter = 0;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.cyan.shade50,
      appBar: AppBar(
        title: Text("Hastalıklar", style:  GoogleFonts.mochiyPopPOne(),),
        backgroundColor: Colors.cyan.shade400,
        centerTitle: true,
        actions: <Widget>[
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
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CheckboxListTile(
                  value: hast1,
                  onChanged: (val){
                    setState(() {
                      hast1 = val!;
                      if(hast1 == true){
                        counter++;
                      }
                    });
                  },
                  activeColor: Colors.green,
                  title: Text("Sarılık"),
              ),
              CheckboxListTile(
                value: hast2,
                onChanged: (val){
                  setState(() {
                    hast2 = val!;
                    if(hast2 == true){
                      counter++;
                    }
                  });
                },
                activeColor: Colors.green,
                title: Text("Solunum Yolu Enfeksiyonu"),
              ),
              CheckboxListTile(
                value: hast3,
                onChanged: (val){
                  setState(() {
                    hast3 = val!;
                    if(hast3 == true){
                      counter++;
                    }
                  });
                },
                activeColor: Colors.green,
                title: Text("İshal"),
              ),
              CheckboxListTile(
                value: hast4,
                onChanged: (val){
                  setState(() {
                    hast4 = val!;
                    if(hast4 == true){
                      counter++;
                    }
                  });
                },
                activeColor: Colors.green,
                title: Text("Alerji"),
              ),
              CheckboxListTile(
                value: hast5,
                onChanged: (val){
                  setState(() {
                    hast5 = val!;
                    if(hast5 == true){
                      counter++;
                    }
                  });
                },
                activeColor: Colors.green,
                title: Text("Kabızlık"),
              ),
              CheckboxListTile(
                value: hast6,
                onChanged: (val){
                  setState(() {
                    hast6 = val!;
                    if(hast6 == true){
                      counter++;
                    }
                  });
                },
                activeColor: Colors.green,
                title: Text("Grip"),
              ),
              CheckboxListTile(
                value: hast7,
                onChanged: (val){
                  setState(() {
                    hast7 = val!;
                    if(hast7 == true){
                      counter++;
                    }
                  });
                },
                activeColor: Colors.green,
                title: Text("Orta Kulak İltihabı"),
              ),
              CheckboxListTile(
                value: hast8,
                onChanged: (val){
                  setState(() {
                    hast8 = val!;
                    if(hast8 == true){
                      counter++;
                    }
                  });
                },
                activeColor: Colors.green,
                title: Text("Bronşit"),
              ),


              Container(
                margin: EdgeInsets.all(25),
                 child: FlatButton(
                    child: Text('Kaydet', style: TextStyle(fontSize: 20.0),),
                       color: Colors.cyan.shade400,
                       textColor: Colors.white,
                       onPressed: () {
                         diseasRef
                             .doc(currentUserId)
                             .set({
                           "id" : currentUserId,
                           "Sarılık": hast1,
                           "Solunum Yolu Enfeksiyonu": hast2,
                           "İshal": hast3,
                           "Alerji": hast4,
                           "Kabızlık": hast5,
                           "Grip": hast6,
                           "Orta Kulak İltihabı" : hast7,
                           "Bronşit": hast8,
                         "count": counter,
                         });
                         diseases = [];
                         dis = "";
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => BabyInfoInf()));

                        },

                 ),
              ),









    ],
        ),
      )
    );
  }
}