import 'package:flutter/material.dart';

class SaveVariables extends ChangeNotifier{
  final List _variable = [];
  List get variable => _variable;

  setValue(Map data){
    _variable.clear();
    _variable.add(data);
    notifyListeners();
  }
  clearValue(){
    _variable.clear();
    notifyListeners();
  }
}