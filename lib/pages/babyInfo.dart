import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby/pages/timeline.dart';
import 'package:baby/pages/user.dart' as u;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import 'checkbox.dart';
import 'home.dart';

List<String>diseases = [];
String dis = "";

int babyMonth = 0;
class BabyInfoInf extends StatefulWidget {

  @override
  BabyInfo createState() => BabyInfo();
}


class BabyInfo extends State<BabyInfoInf> {
  late u.User user;
  String babyName = "";
  String motherName = "";
  String babyHeight = "";
  String babyWeight = "";
  String birthday = "";

  List<String>diseases = [];
  String dis = "";
  String paragraph = "";

  @override
  void initState() {
    getUser();
    getDiseases();
    super.initState();

    //calcTime();
  }
  getUser()async{
    DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
    user = u.User.fromDocument(doc);
    if(mounted) {
      setState(() {
        babyName = user.babyName;
        motherName = user.userName;
        babyWeight = user.babyWeight;
        babyHeight = user.babyHeight;
        birthday = user.birthday;
      });
    }
    //calcTime();
  //  getDiseases();



  }




  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
            backgroundColor: Colors.purple,
            title: Text(
            "Bebek",
            style:  GoogleFonts.mochiyPopPOne(

            color: Colors.white,
          ),
          ),
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

      body: ListView(
          children: [
            //children: [
              SizedBox(
                height: 20,
              ),
              _heading("Bebe??iniz Hakk??nda"),
              SizedBox(
                height: 6,
              ),
              _detailsCard(),
              SizedBox(
                height: 10,
              ),
              _heading("Bu aylarda neler olur? "),
              SizedBox(
                height: 6,
              ),
              _settingsCard(),
              Spacer(),
              //logoutButton()
            ],
      //    )
      ),


    );
  }

  int calcTime(){

    DateTime now = new DateTime.now();
    DateTime dt = DateTime.parse(now.toString());
    List miray = dt.toString().split("-");
    List miray2 = miray[2].split(" ");

    List birt = birthday.split(".");

    var a1 = int.parse(miray[0]);
    var a2 = int.parse(miray[1]);
    var a3 = int.parse(miray2[0]);

    var b1 = int.parse(birt[2]);
    var b2 = int.parse(birt[1]);
    var b3 = int.parse(birt[0]);

    int todayMonth = (a1*12) + a2;
    int birtMonth = (b1*12) + b2;
    int month = 0;
    if(a3 < b3){
      month = (todayMonth - birtMonth) - 1;
    } else {
      month = (todayMonth - birtMonth);
    }


    setState(() {
      babyMonth = month;
    });

    return babyMonth;


  }





  Widget _heading(String heading) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Text(
        heading,
        style: TextStyle(
            fontSize: 22,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
        ),

      ),
    );
  }

  Widget _detailsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.pink.shade100,
        elevation: 4,
        child: Column(
          children: [
            //row for each deatails
            ListTile(
              //leading: Icon(Icons.email),
              title: Text("Bebe??in ad?? : " + babyName,
                         style: TextStyle(fontStyle: FontStyle.normal)),
            ),
            ListTile(
              //leading: Icon(Icons.phone),
              title: Text("Bebe??in Kilosu : " + babyWeight + " gram"),
            ),
            ListTile(
              //leading: Icon(Icons.phone),
              title: Text("Bebe??in Boyu : " + babyHeight + " santimetre"),
            ),
            ListTile(
              //leading: Icon(Icons.phone),
              title: Text("Bebe??in Do??um Tarihi : " + birthday),
            ),
            ListTile(
              //leading: Icon(Icons.settings),
              leading: Icon(
                Icons.settings ,

                color: Colors.white,
                size: 40,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckBox()));
              },
              title: Text("Hastal??klar: " + dis),


            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard() {
    getHealth();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.cyan.shade100,
        elevation: 4,

          child: Column(
            children: [
              //row for each deatails

              ListTile(
                //leading: Icon(Icons.dashboard_customize),
                title: Text(paragraph,
                style: GoogleFonts.dmSerifDisplay(fontStyle: FontStyle.italic, fontSize: 17),),
              ),

            ],
          ),
       
      ),
    );
  }

  getHealth()async{

    calcTime();
    if(babyMonth == 0){
      babyMonth = 1;
    }
      final DocumentSnapshot doc = await babyRef.doc(babyMonth.toString()).get();

    if (this.mounted) {
      setState(() {
        paragraph = doc['info'];
      });
    }

  }

  getDiseases()async{

    final DocumentSnapshot doc = await diseasRef.doc(currentUserId).get();
    if (this.mounted) {
      setState(() {
        if (doc['Alerji'] == true) {
          diseases.add("Alerji");
        }
        if (doc['Bron??it'] == true) {
          diseases.add("Bron??it");
        }
        if (doc['Grip'] == true) {
          diseases.add("Grip");
        }
        if (doc['Kab??zl??k'] == true) {
          diseases.add("Kab??zl??k");
        }
        if (doc['Orta Kulak ??ltihab??'] == true) {
          diseases.add("Orta Kulak ??ltihab??");
        }
        if (doc['Sar??l??k'] == true) {
          diseases.add("Sar??l??k");
        }
        if (doc['Solunum Yolu Enfeksiyonu'] == true) {
          diseases.add("Solunum Yolu Enfeksiyonu");
        }
        if (doc['Bron??it'] == true) {
          diseases.add("Su ??i??e??i");
        }
        if (doc['??shal'] == true) {
          diseases.add("??shal");
        }

        dis = diseases.join(", ");

      });
    }

  }




  Widget logoutButton() {
    return InkWell(
      onTap: () {},
      child: Container(
          color: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
               /* Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )*/
              ],
            ),
          )),
    );
  }
}

