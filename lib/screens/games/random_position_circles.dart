import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mined/screens/games/classes/count_time.dart';
import 'package:mined/screens/games/service/round_counter.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import 'classes/exit_game.dart';
import 'pages/result_time.dart';

class RandomPositionCircles extends StatefulWidget {
  final String title;
  final String body;
  const RandomPositionCircles({super.key, required this.title, required this.body});

  @override
  State<RandomPositionCircles> createState() => _RandomPositionCirclesState();
}

class _RandomPositionCirclesState extends State<RandomPositionCircles> {
  double _circleLeft = 0;
  double _circleTop = 0;
  final Random _random = Random();
  bool selectedCircle = false;
  bool failPress = false;
  int maxRounds = 10;
  double userSeconds = 0.0;
  int failedAttemptsCount = 0;
  
  void _updateCirclePosition(){
    setState(() {
      _circleLeft = Random().nextDouble() * (300 - 100) + 100;
      _circleTop = _random.nextDouble() * (500 - 50) + 50;
    });
  }

  void setWrongPress(){
    setState(() {
      failPress = true;
    });
    Future.delayed(const Duration(milliseconds: 500), (){
      setState(() {
        failedAttemptsCount++;
        failPress = false;
      });
    });
  }

  @override
  void initState() {
    CountTime.startTimer();
    _updateCirclePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<RoundCounter>(
        builder: (context, prov, child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: (() => setWrongPress()),
                child: Container(
                  width: w,
                  height: h,
                  color: selectedCircle ?AppColors.screenGreen : failPress ?AppColors.screenRed  :AppColors.white,
                  child: Stack(
                    children: [
                    exitGame(
                        title: widget.title,
                        body: widget.body,
                        page: RandomPositionCircles(title: widget.title, body: widget.title),
                        context: context
                      ),
                      Positioned(
                        left: _circleLeft,
                        top: _circleTop,
                        child: GestureDetector(
                          onTap: (){
                            if(!failPress){
                              if(!prov.endgame){
                                setState(() => selectedCircle = true);
                                CountTime.updateCounterAndNavigate(context, prov, failedAttemptsCount, RandomPositionCircles(title: widget.title, body: widget.body,), prov.roundNumber, false);
                              }
                            }
                          },
                          child: Container(
                            width: 65,
                            height: 65, 
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedCircle ?AppColors.lightGreen : failPress ?AppColors.red :AppColors.mov,
                              border: Border.all(color: selectedCircle ? AppColors.openGreen : failPress ? AppColors.openRed :AppColors.openMov, width: 10)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ResultTime(prov: prov,),
            ],
          );
        }
      ),
    );
  }
}