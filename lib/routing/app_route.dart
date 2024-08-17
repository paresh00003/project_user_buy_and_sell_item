import 'package:flutter/material.dart';
import 'package:local_buy_and_sell/pages/item/add_item.dart';
import 'package:local_buy_and_sell/pages/payment/paymentPage.dart';
import '../constant/app_constant.dart';
import '../pages/Home/home_page.dart';
import '../pages/item/sell_item_show.dart';
import '../pages/login/login_page.dart';
import '../pages/onboarding/onboarding_view.dart';
import '../pages/splash/splash.dart';




class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //setting pass names and arguments

    switch (settings.name) {

      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );

      case AppConstant.OnBoardingView:
        return MaterialPageRoute(
          builder: (context) => OnBoardingScreen(),
        );

      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );

      case AppConstant.homeView:
        return MaterialPageRoute(
          builder: (context) => HomeView(),
        );

      case AppConstant.sellitem:
        return MaterialPageRoute(
          builder: (context) => SellItemList(),
        );

      case AppConstant.additem:
        return MaterialPageRoute(
          builder: (context) => AddItemPage(),
        );






      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
