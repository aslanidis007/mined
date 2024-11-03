import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mined/routes/auth_route.dart';
import 'package:mined/routes/routes.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
        Container(
            width: w,
            height: h,
            decoration:  const BoxDecoration(
              color: AppColors.mov,
              image: DecorationImage(
                repeat: ImageRepeat.repeat,
                opacity: .25,
                image: AssetImage(AppAssets.loginBackgroundImage),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: w,
              height: h/1.5,
              decoration: const BoxDecoration(
                color: AppColors.darkMov,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(500), 
                  bottomRight: Radius.circular(500)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppAssets.logo),
                    const SizedBox(height: 140.0,),
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    const Text(
                      'We are thrilled to have you on board! Join us \non a transformative journey towards mental \nresilience, and a supportive community \ndedicated to optimizing your performance and \nwell-being.',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: w,
              height: h/3,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(500), 
                  topRight: Radius.circular(500)
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await nextScreen(context);
                    },
                    child: Container(
                      width: w * 0.8,
                      height: 50.0,
                      margin: const EdgeInsets.only(bottom: 45.0),
                      decoration: BoxDecoration(
                        color:AppColors.lightGreen,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightGreen.withOpacity(0.6),
                            spreadRadius: 3,
                            blurRadius: 20,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: const Center(
                        child: Text(
                          'Get Started',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 240,
            left: 125,
            child: Image.asset(AppAssets.hand, height: 100,),
          ),
        ],
      ),
    );
  }

  nextScreen(context) async{
    Widget page = await AuthRoute(ctx: context).navigateController();
    PageNavigator(ctx: context).nextPage(page: page);
  }
}