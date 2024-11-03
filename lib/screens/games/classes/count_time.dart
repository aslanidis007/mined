import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../routes/routes.dart';
import '../pages/rounds.dart';
import '../service/round_counter.dart';

class CountTime{
  static DateTime? _startTime;

  static startTimer() {
    _startTime = DateTime.now();
  }
  
  static stopTimer() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(_startTime!);
    return difference.inMilliseconds.toDouble();
  }
  static updateCounterAndNavigate(final context, RoundCounter prov, failedAttemptsCount, Widget? page, int maxRound, bool isSkip) async{
    double userSeconds = stopTimer();
    Provider.of<RoundCounter>(context, listen: false).addCounter();
    if(isSkip){
      prov.addNewResponses(null, null);
    }else{
      prov.addNewResponses(userSeconds/1000, failedAttemptsCount);
    }
    if(prov.responses.length < maxRound){
      PageNavigator(ctx: context).nextPageOnly(
        page: Rounds(
          title: 'Round ${Provider.of<RoundCounter>(context, listen: false).counter + 1}',
          page: page!,
        ),
      );
    }else{
      prov.stopGame();
    }
  }
}