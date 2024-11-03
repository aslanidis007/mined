import 'dart:developer';

import 'package:flutter/material.dart';

class ResponseModel extends ChangeNotifier {
  final Map _responses = {'responses':{}};
  Map get responses => _responses;

  resetResponses(){
    _responses.clear();
  }

  void setResponse(
    int questionId,
    int selectedResponseOptionId,
    String selectedResponseOptionLabel,
    int? selectedResponseOptionValue,
    String? selectedResponseOptionText,
    bool isMultipleChoice,
  ) {
    // Check if the questionId already exists in the responses map
    if(isMultipleChoice){

       if (!_responses.containsKey('$questionId')) {
      _responses['$questionId'] = []; // Initialize the list for this questionId
    }

    final response = {
      'question_id': questionId,
      'selected_response_option_id': selectedResponseOptionId,
      'selected_response_option_label': selectedResponseOptionLabel,
      'selected_response_option_value': selectedResponseOptionValue,
      'selected_response_option_text': selectedResponseOptionText
    };

    _responses['$questionId']!.add(response);

    }else{
      if (_responses.containsKey(questionId)) {
        _responses["$questionId"] = {
          'question_id' : questionId,
          'selected_response_option_id' : selectedResponseOptionId,
          'selected_response_option_label' : selectedResponseOptionLabel,
          'selected_response_option_value' : selectedResponseOptionValue,
          'selected_response_option_text': selectedResponseOptionText
        };
      } else {
        _responses["$questionId"] = {
          'question_id' : questionId,
          'selected_response_option_id' : selectedResponseOptionId,
          'selected_response_option_label' : selectedResponseOptionLabel,
          'selected_response_option_value' : selectedResponseOptionValue,
          'selected_response_option_text' : selectedResponseOptionText
        };
      }
    }
    log(_responses.toString());
    notifyListeners();
  }
}