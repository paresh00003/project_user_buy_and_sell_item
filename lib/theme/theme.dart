import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),



    actionIconTheme: ActionIconThemeData(),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(titleMedium: TextStyle()),


    floatingActionButtonTheme: FloatingActionButtonThemeData(

      backgroundColor: Colors.blue.shade200,


    )

  );
}
