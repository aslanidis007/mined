import 'package:flutter/foundation.dart';

class RecordData extends ChangeNotifier{
  Map data = {};

  setData(int counter, bool? check){
    data[counter] = check ?? false;
  }
  clearData(){
    data.clear();
  }
}