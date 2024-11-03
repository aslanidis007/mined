import 'package:flutter/material.dart';

class RoundCounter extends ChangeNotifier{
  int counter = 0;
  bool endgame = false;
  int responseCount = 0;
  double timeAverage = 0.0;
  int roundNumber = 10;
  final Map _responses = {};
  Map get responses => _responses;


  void addNewResponses(double? time, int? failedAttempts){
    responses['${responseCount++}'] = {'time': time, "failed_attempts": failedAttempts};
    notifyListeners();
  }
  

  void addCounter(){    
    counter ++;    
    notifyListeners();
  }

  void stopGame(){
    endgame = true;
    double totalTime = 0.0;
    for (var respo in responses.values) {
        totalTime += respo['time'] ?? 0.0;
    }
    timeAverage = totalTime / responses.length;
    notifyListeners();
  }

  void resetCounter(){
    counter = 0;
    endgame = false;
    _responses.clear();
    timeAverage = 0.0;
    responseCount = 0;
    notifyListeners();
  }
}