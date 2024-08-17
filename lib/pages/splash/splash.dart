import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_constant.dart';
import '../Home/home_page.dart';
import '../login/login_page.dart';

import '../onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
             // User is already signed in, navigate to home page
      Navigator.pushReplacementNamed(context, AppConstant.homeView);
    } else {

      Navigator.pushReplacementNamed(context, AppConstant.OnBoardingView);
    }
  }

  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: Size.width,
                  child: Image(
                    image: AssetImage("assets/images/splash3.png"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Buy and Sell",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                    fontSize: 40,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
