import 'dart:developer';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/assets.dart';
import '../constants/color.dart';
import 'service/load_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Provider.of<LoadPage>(context, listen: false).loadPage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget defaultWidget = Container(
      width: 40,
      height: 40,
      color: AppColors.mov,
      child: const Center(
        child: CircularProgressIndicator(
        strokeWidth: 15,
        color: AppColors.white,)
      ),
    );
    return AnimatedSplashScreen(
      backgroundColor: AppColors.mov,
      splash: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppAssets.logo, width: 250,),
        ],
      ), nextScreen: Consumer<LoadPage>(
        builder: (context, data, child) {
          if(data.page == null){
            log(':::[Message Route] => Load Page...');
            return defaultWidget;
          }
          return data.page!;
        }
      ),
      splashIconSize: 250,
      duration: 2000,
      splashTransition: SplashTransition.scaleTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
