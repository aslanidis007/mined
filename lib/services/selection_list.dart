import 'package:flutter/material.dart';

class AnswerSelection extends ChangeNotifier {
  final Map<int, List<Selected>> _choose = {};
  Map<int, List<Selected>> get choose => _choose;
  bool _isSelected = false; // Correct the return type here
  bool get isSelected => _isSelected;
  
  resetChoose() {
    _choose.clear();
    notifyListeners();
  }

  resetSelection(){
    _isSelected = false;
    notifyListeners();
  }

  setSelectedTrue(){
    _isSelected = true;
    notifyListeners();
  }

  void setChoose(
    int id,
    int index,
    bool isMultipleSelection,
  ) {
    if (!isMultipleSelection) {
      // If it's not a multiple choice question, clear any existing responses
      _choose.remove(id);

      // Create a new response for the single-choice question
      final response = Selected(id: id, index: index);
      _choose[id] = [response]; 
      final selectedSingleAnswers = _choose[id]!;
      if(selectedSingleAnswers.isEmpty){
        _isSelected = false;
      }else{
        _isSelected = true;
      }
      notifyListeners();
    } else {
      if (!_choose.containsKey(id)) {
        _choose[id] = []; // Initialize the list for this question
      }

      bool alreadySelected = false;
      final selectedAnswers = _choose[id]!;

      // Check if the option is already selected
      for (int i = 0; i < selectedAnswers.length; i++) {
        if (selectedAnswers[i].index == index) {
          alreadySelected = true;
          selectedAnswers.removeAt(i); // Deselect if already selected
          break;
        }
      }

      if (!alreadySelected) {
        final response = Selected(id: id, index: index);
        selectedAnswers.add(response); // Select the answer
      }

      if (selectedAnswers.isEmpty) {
        _choose.remove(id); // Remove the question if no answer selected
        _isSelected = false; // Set isSelected to false if no answers selected
      }else{
        _isSelected = true; // Set isSelected to false if no answers selected
      }
      notifyListeners();
    }

    notifyListeners();
  }
}

class Selected {
  int? id;
  int? index;

  Selected({
    required this.id,
    required this.index,
  });
}
