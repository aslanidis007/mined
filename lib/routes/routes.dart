
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mined/authorization/login.dart';
import 'package:mined/authorization/splash.dart';
import 'package:mined/routes/router.dart';
import 'package:mined/screens/intro/welcome.dart';
import 'package:mined/screens/menu/bottom_menu.dart';
import 'package:mined/screens/widgets/version_alert.dart';
import '../screens/widgets/banned_alert.dart';

class PageNavigator {
  PageNavigator({this.ctx});
  BuildContext? ctx;

  ///Navigator to next page
  Future nextPage({Widget? page}) {
    return Navigator.push(
        ctx!, CupertinoPageRoute(builder: ((context) => page!),));
  }

  Future replaceNextPage({Widget? page}) {
    return Navigator.pushReplacement(
        ctx!, CupertinoPageRoute(builder: ((context) => page!),));
  }

  nextPageOnly({Widget? page}) {
    Navigator.pushAndRemoveUntil(
        ctx!, MaterialPageRoute(builder: (context) => page!), (route) => false);
  }

}

Route<dynamic> onGenerate(RouteSettings settings,) {
  switch (settings.name) {
    case AppRoutes.splashScreen:
       return CupertinoPageRoute(
         builder: (_) => const SplashScreen(),
         settings: settings
       );
    case AppRoutes.homePage:
      return CupertinoPageRoute(
        builder: (_) => const BottomMenu(),
        settings: settings,
      );
    case AppRoutes.introPage:
      return CupertinoPageRoute(
        builder: (_) => const IntroPage(),
        settings: settings,
      );
    case AppRoutes.bannedPage:
      return CupertinoPageRoute(
        builder: (_) => const BannedAlert(),
        settings: settings,
      );
    case AppRoutes.versionPage:
      return CupertinoPageRoute(
        builder: (_) => const VersionAlert(),
        settings: settings,
      );
    case AppRoutes.loginPage:
      return CupertinoPageRoute(
        builder: (_) => const LoginPage(),
        settings: settings,
      );
    default:
      return CupertinoPageRoute(
        builder: (_) => const LoginPage(),
        settings: settings,
      );
  }
}