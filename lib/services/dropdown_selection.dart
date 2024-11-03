import 'package:flutter/material.dart';


class DropDownSelection extends ChangeNotifier{
  bool _visible = false;
  bool get visible => _visible;

  List<bool> _selectItem = [];
  List<bool> get selectItem => _selectItem;

  String _selectedItemValue = '';
  String get selectedItemValue => _selectedItemValue;

  bool _visibleTextArea = false;
  bool get visibleTextArea => _visibleTextArea;

  int? _typeId;
  int? get typeId => _typeId;

  bool _isHaveEndDate = false;
  bool get isHaveEndDate => _isHaveEndDate;


  clearSelection(){
    _visible = false;
    _selectItem = [];
    _selectedItemValue = '';
    _visibleTextArea = false;
    _typeId = null;
    _isHaveEndDate = false;
    notifyListeners();
  }

  dropdownIsVisible(List data){
    if(data.isNotEmpty){
      _visible = !_visible;
    }
    notifyListeners();
  }

  totalItemForSelect(List data){
    for(var index = 0; index < data.length; index ++){
      _selectItem.add(false);
    }
    notifyListeners();
  }

  selectType(int index, String name, List selected){
    for (int i = 0; i < selected.length; i++){
      if(i == index){
          selected[i] = !selected[i];
          if(selected[i] == false){
            _selectedItemValue = '';
          }else{
            _selectedItemValue = name;
            _visible = false;
          }
          // medicalId = index;
      }else{
        selected[i] = false;
      }
    }
    notifyListeners();
  }

  selectTypeForEvent(Map data,int index,BuildContext context, List selected) async{
    for (int i = 0; i < selected.length; i++){
      if(i == index){
          selected[i] = !selected[i];
          if(selected[i] == false){
            _isHaveEndDate = false;
            _selectedItemValue = '';
            _typeId = null;
            selected[i] = false;
          }else{
            _selectedItemValue = data['name'].toString();
            _visibleTextArea = false;
            if(_selectedItemValue == 'OTHER'){
              _visibleTextArea = true;
            }
            _typeId = data['id'];
            _visible = false;
          }
          if(data['multi_date'] == 0){
            _isHaveEndDate = false;
          }else{
            _isHaveEndDate = true;
          }
      }else{
        selected[i] = false;
      }
    }
    notifyListeners();
  }
}