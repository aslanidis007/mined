import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/games/pages/result_time.dart';
import 'package:mined/screens/games/service/rember_number_text.dart';
import 'package:provider/provider.dart';

import '../../constants/color.dart';
import '../../translations/locale_keys.g.dart';
import 'classes/exit_game.dart';
import 'service/round_counter.dart';

class RememberNumber extends StatefulWidget {
  final String title;
  final String body;
  const RememberNumber({super.key, required this.title, required this.body});

  @override
  State<RememberNumber> createState() => _RememberNumberState();
}

class _RememberNumberState extends State<RememberNumber> {
  List numbers = [];
  FlutterTts flutterTts = FlutterTts();



  generateRandomNumbers(BuildContext context) async{
    Random rand = Random();
    int responsesLength = Provider.of<RoundCounter>(context, listen: false).responses.length;
    int columnLength;
    int countTalk = 1;
    String allNumbers = '';

    if(responsesLength == 0 || responsesLength == 3) {
      columnLength = 3;
    } else if (responsesLength == 1 || responsesLength == 4) {
      columnLength = 4;
    } else {
      columnLength = 5;
    }

    for (int i = 0; i < columnLength; i++) {
      int randomNumber = rand.nextInt(9) + 1;
      numbers.add(randomNumber);
      allNumbers += '${numbers[i]}';
    }
    await flutterTts.setVolume(1.0);
    if(context.locale == const Locale('en')){
      await flutterTts.setLanguage("en-US");
    }else{
      await flutterTts.setLanguage("el-GR");
    }
    while(countTalk < 3){
      countTalk++;
      if(countTalk == 3){
        await flutterTts.speak(context.tr(LocaleKeys.repeat));
        await Future.delayed(const Duration(milliseconds:  1800));
        for(var x = 0; x < numbers.length; x++){
          await flutterTts.speak(numbers[x].toString());
          await Future.delayed(const Duration(milliseconds:  1700));
        }
        PageNavigator(ctx: context).nextPageOnly(page: RememberNumberText(numbers: allNumbers, title: widget.title, body: widget.body,));
      }else{
        for(var x = 0; x < numbers.length; x++){
          await flutterTts.speak(numbers[x].toString());
          await Future.delayed(const Duration(milliseconds:  1700));
        }
      }
    }
    setState(() {});
  }


  @override
  void initState() {
    generateRandomNumbers(context);
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
                page: RememberNumber(title: widget.title, body: widget.title),
                context: context
              ),
              Container(
                width: w,
                height: h,
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 120.0),
                child: Column(
                  children: [
                    const Text(
                      'Remember the these numbers.',
                      style: TextStyle(
                        color: AppColors.darkMov,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(numbers.length,(index) => Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            color: AppColors.numberUnselectedColor,
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightMov.withOpacity(0.2),
                                spreadRadius: 0.0,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${numbers[index]}',
                              style: const TextStyle(
                                color: AppColors.darkMov,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
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