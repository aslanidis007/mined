import 'package:flutter/material.dart';

class HideNavBar extends ChangeNotifier{
  bool _hideNavBar = false;
  bool? get hideNavBar => _hideNavBar;

  isHide(){
    _hideNavBar = true;
    notifyListeners();
  }
  isVisible(){
    _hideNavBar = false;
    notifyListeners();
  }
}