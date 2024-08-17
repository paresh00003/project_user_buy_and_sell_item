import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:local_buy_and_sell/pages/Home/home_page.dart';
import 'package:local_buy_and_sell/pages/splash/splash.dart';
import 'package:local_buy_and_sell/routing/app_route.dart';
import 'package:local_buy_and_sell/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (kIsWeb) {

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDTwvzMDGPfBvQpOR43p2Ev6n4lKtb-8VE",
        authDomain: "local-sell-and-buy.firebaseapp.com",
        projectId: "local-sell-and-buy",
        storageBucket: "local-sell-and-buy.appspot.com",
        messagingSenderId: "819091825792",
        appId: "1:819091825792:web:8213b4c746402bd0fc7265",
        measurementId: "G-ZRMV3P14SX",
      ),
    );
  } else if (Platform.isAndroid) {

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD-ew1nR-LK2EBNtTBXt0F9ncqgw7p-04M",
        appId: "1:819091825792:android:90eb56b1365257effc7265",
        messagingSenderId: "819091825792",
        projectId: "local-sell-and-buy",
        storageBucket: "local-sell-and-buy.appspot.com",
      ),
    );
  } else if (Platform.isIOS) {

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDEZEGyu3eEJqdaqor6vjscugcyFIw-HSs",
        appId: "1:819091825792:ios:4494a92b88d47f6efc7265",
        messagingSenderId: "819091825792",
        projectId: "local-sell-and-buy",
        storageBucket: "local-sell-and-buy.appspot.com",
      ),
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'local_buy_and_sell',
      theme: appTheme(context),
      onGenerateRoute: AppRoute.generateRoute,
      home: _getLandingPage(),
    );
  }
}

Widget _getLandingPage() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {

    return const HomeView();
  } else {

    return const SplashView();
  }
}






  //App Icon Change karva mate


// dev_dependencies:
//   flutter_launcher_icons: "^0.13.1"
//
// flutter_launcher_icons:
//   android: "launcher_icon"
//   ios: true
//   image_path: "assets/icon/icon.png"


// flutter pub run flutter_launcher_icons

 //run this command on terminal



