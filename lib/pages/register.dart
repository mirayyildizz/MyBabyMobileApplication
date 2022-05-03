import 'package:baby/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'checkbox.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _babynameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _babyheightController = TextEditingController();
  final TextEditingController _babyweightController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  bool _babynameValid = true;
  bool _displayNameValid = true;
  bool _birthdayValid = true;
  bool _babyWeightValid = true;
  bool _babyHeightValid = true;
  bool _passwordValid = true;
  bool isTrue = false;
  bool _emailValid = true;

  AuthService _authService = AuthService();

  bool parolaValid(TextEditingController passwordController) {
    String? parola = passwordController.text;

    print(parola.length);

    if(_passwordController != null && parola != null) {
      if (parola.isNotEmpty) {
        if (parola.length < 6) {
          return false;
        }
        return true;
      }
    }

    return true;
  }

  updateProfileData(){
    setState(() {
      _nameController.text.trim().length < 3 ||
          _nameController.text.isEmpty ? _displayNameValid = false :
      _displayNameValid = true;
      _babynameController.text.trim().length < 3 || _nameController.text.isEmpty ?  _babynameValid = false :
      _babynameValid = true;

      List birt = _birthdayController.text.split(".");
      print(birt[0]);
      print(int.parse(birt[0]));
      if(_birthdayController.text.length < 8){
        _birthdayValid = false;
      } else if(int.parse(birt[0]) > 31 || int.parse(birt[0]) < 0){
        _birthdayValid = false;
      } else if(int.parse(birt[1]) > 12 || int.parse(birt[1]) < 0){
        _birthdayValid = false;
      } else{
        _birthdayValid = true;
      }

      if(int.parse(_babyweightController.text) < 0){
        _babyWeightValid = false;
      } else {
        _babyWeightValid = true;
      }

      if(int.parse(_babyheightController.text) < 0){
        _babyHeightValid = false;
      } else {
        _babyHeightValid = true;
      }

      if(_emailController.text.contains("@")){
        _emailValid = true;
      } else {
        _emailValid = false;
      }

      if(_passwordController.text.length < 6){
        _passwordValid = false;
      } else {
        _passwordValid = true;
      }

    });

    if(_displayNameValid && _babynameValid && _birthdayValid && _babyWeightValid && _babyHeightValid && _emailValid && _passwordValid){
      _authService
          .createPerson(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _babyweightController.text,
          _babynameController.text,
          _babyheightController.text,
          _controller.text,
          _birthdayController.text)
          .then((value) {
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckBox()));
      });
      SnackBar snackbar = SnackBar(content: Text("Profil Oluşturuldu!"));
      _scaffoldKey.currentState!.showSnackBar(snackbar);
    }

  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.yellow.shade50,
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .98,
                  width: size.width * .99,
                  decoration: BoxDecoration(
                      color: Colors.purple.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.75),
                            blurRadius: 10,
                            spreadRadius: 2)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            TextField(
                                controller: _nameController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Anne Adı',
                                  prefixText: ' ',
                                  errorText: _displayNameValid ? null : "Girilen isim çok kısa, lütfen geçerli bir isim giriniz", errorStyle: TextStyle(fontWeight: FontWeight.bold),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                )),

                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextField(
                                controller: _babynameController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Bebek Adı',
                                  prefixText: ' ',
                                  errorText: _babynameValid ? null : "Girilen isim çok kısa, lütfen geçerli bir isim giriniz", errorStyle: TextStyle(fontWeight: FontWeight.bold),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                )),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextField(
                                controller: _birthdayController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                  helperText: 'gg.aa.yyyy şeklinde giriniz.',
                                  hintText: 'Bebeğin Doğum Tarihi',
                                  prefixText: ' ',
                                  errorText: _birthdayValid ? null : "Lütfen geçerli bir tarih giriniz (gg.aa.yyyy)", errorStyle: TextStyle(fontWeight: FontWeight.bold),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                )),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextField(
                                controller: _babyweightController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.monitor_weight,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Bebeğin Kilosu',
                                  errorText: _babyWeightValid ? null : "Lütfen geçerli bir kilo giriniz.", errorStyle: TextStyle(fontWeight: FontWeight.bold),
                                  helperText: 'Gram cinsinden giriniz.',
                                  prefixText: ' ',
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                )),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextField(
                                controller: _babyheightController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.height,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Bebeğin Boyu',
                                  prefixText: ' ',
                                  errorText: _babyHeightValid ? null : "Lütfen geçerli bir boy giriniz.", errorStyle: TextStyle(fontWeight: FontWeight.bold),
                                  helperText: 'Santimetre cinsinden giriniz.',
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                )),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextField(
                                controller: _emailController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                  ),
                                  hintText: 'E-Mail',
                                  prefixText: ' ',
                                  errorText: _emailValid ? null : "Lütfen geçerli bir email giriniz.", errorStyle: TextStyle(fontWeight: FontWeight.bold),
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                )),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Parola',
                                  prefixText: ' ',
                                  errorText: _passwordValid ? null : "Lütfen daha güçlü bir şifre giriniz.", errorStyle: TextStyle(fontWeight: FontWeight.bold),
                                  //errorText: isTrue ? null : "Display Name too long",
                                  hintStyle: TextStyle(color: Colors.white),
                                  focusColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )),

                                ))
                            ,
                            SizedBox(
                              height: size.height * 0.02,
                            ),

                            InkWell(
                              onTap: () {
                                updateProfileData();
                              },

                              child: Container(

                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(

                                    border: Border.all(color: Colors.white, width: 2),
                                    //color: colorPrimaryShade,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                                child: Padding(

                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                        "Kaydet",
                                        style:  GoogleFonts.mochiyPopPOne(color: Colors.purple.shade50, fontSize: 20,),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding:
              EdgeInsets.only(top: size.height * .06, left: size.width * .02),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.blue.withOpacity(.75),
                        size: 26,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.2,
                    ),
                    Text(
                      "Kayıt ol              ",
                      style:  GoogleFonts.mochiyPopPOne(color: Colors.purple.shade50, fontSize: 30,),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

