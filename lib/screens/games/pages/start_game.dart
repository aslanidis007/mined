import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mined/screens/games/pages/rounds.dart';
import 'package:provider/provider.dart';
import '../../../constants/assets.dart';
import '../../../constants/color.dart';
import '../../../routes/routes.dart';
import '../../menu/bottom_menu.dart';
import '../service/round_counter.dart';

class StartGame extends StatefulWidget {
  final Widget page;
  final String title;
  final String body;
  const StartGame({super.key, required this.page, required this.title, required this.body});

  @override
  State<StartGame> createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
@override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white.withOpacity(0.95),
      body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 55.0, bottom: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        PageNavigator(ctx: context).nextPageOnly(page: const BottomMenu());
                      },
                      child: const Icon(
                        Icons.close, 
                        size: 38, 
                        color: AppColors.lightMov,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: w,
                  height: h * 0.88,
                  padding: EdgeInsets.only(top: h * 0.18,left: 20,right: 20),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)
                    )
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Cognitive test',
                        style: TextStyle(
                          color: AppColors.mov,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      Text(
                        widget.body,
                        style: const TextStyle(
                          color: AppColors.lightMov,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Provider.of<RoundCounter>(context, listen:false).resetCounter();
                      PageNavigator(ctx: context).nextPage(page: Rounds(title: 'Round 1',page: widget.page));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: w * 0.8,
                    decoration:  BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGreen.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: const Text(
                      'Tap to start',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  AppAssets.tap,
                  width: 110,
                  height: 145,
                ),
              ),
            ],
          ),
    );
  }
}