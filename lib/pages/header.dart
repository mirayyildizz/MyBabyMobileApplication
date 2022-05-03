import 'package:flutter/material.dart';

AppBar header(BuildContext context, { bool isAppTitle = false, required String titleText }) {
  return AppBar(
    title: Text(
      isAppTitle ? "MyBaby App" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Raleway" : "",
        fontSize: isAppTitle ? 30.0 : 15.0,
        fontStyle: FontStyle.italic
      ),
      overflow: TextOverflow.ellipsis,
    ),

    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}