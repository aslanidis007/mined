import 'package:flutter/material.dart';
import 'package:mined/screens/games/pages/result_time.dart';
import 'package:mined/screens/games/remember_numbers.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';
import '../classes/count_time.dart';
import '../classes/exit_game.dart';
import '../classes/skip.dart';
import 'round_counter.dart';

// ignore: must_be_immutable
class RememberNumberText extends StatefulWidget {
  final String numbers;
  final String title;
  final String body;
  const RememberNumberText({super.key, required this.numbers, required this.body, required this.title});

  @override
  State<RememberNumberText> createState() => _RememberNumberTextState();
}

class _RememberNumberTextState extends State<RememberNumberText> {
  int failedAttemptsCount = 0;
  bool isCorrect = false;

  String reverseNumber(int number) {
    int reversed = 0;
    while (number > 0) {
      reversed = reversed * 10 + number % 10;
      number ~/= 10;
    }
    return reversed.toString();
  }

  @override
  void initState() {
    CountTime.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<RoundCounter>(
        builder: (context, prov, child) {
          return Stack(
            children: [
              exitGame(
                title: widget.title,
                body: widget.body,
                page: RememberNumber(title: widget.title, body: widget.body),
                context: context
              ),
              skipRound(
                page: RememberNumber(title: widget.title, body: widget.body),
                context: context,
                prov: prov,
              ),
              Container(
                width: w,
                height: h,
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 120.0),
                child: Column(
                  children: [
                    if(prov.counter < 3)...[
                      const Text(
                        'Now put them in increasing order.',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]else...[
                      const Text(
                        'Now put them in decreasing order.',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const Spacer(),
                      Pinput(
                        autofocus: true,
                        defaultPinTheme: PinTheme(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        textStyle: const TextStyle(fontSize: 20, color: AppColors.darkMov, fontWeight: FontWeight.w600),
                        decoration: BoxDecoration(
                          color:AppColors.numberUnselectedColor,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightMov.withOpacity(0.2),
                              spreadRadius: 0.0,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                      ),
                      length: widget.numbers.length,
                      validator: (s) {
                      if(prov.counter < 3){
                        if(s != widget.numbers){
                          setState(() => failedAttemptsCount++);
                          return 'Numbers is incorrect';
                        }else{
                          CountTime.updateCounterAndNavigate(context, prov, failedAttemptsCount, RememberNumber(title: widget.title,body: widget.body,), 6, false);
                          return null;
                        }
                      }else{
                        if(s != reverseNumber(int.parse(widget.numbers))){
                          setState(() => failedAttemptsCount++);
                          return 'Numbers is incorrect';
                        }else{
                          CountTime.updateCounterAndNavigate(context, prov, failedAttemptsCount, RememberNumber(title: widget.title,body: widget.body,), 6, false);
                          return null;
                        }
                      }
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                    ), 
                    const Spacer(),
                  ],
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