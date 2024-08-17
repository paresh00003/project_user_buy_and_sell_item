import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Color backgroundcolor;
  String text;
  Color textcolor;
  VoidCallback onclick;

  CustomButton(
      {required this.backgroundcolor,
      required this.text,
      required this.textcolor,
      required this.onclick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width * 0.5,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundcolor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18, color: textcolor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
