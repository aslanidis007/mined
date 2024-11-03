import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api/leave_feedback.dart';
import '../constants/save_local_storage.dart';

class LeaveFeedBackService extends ChangeNotifier{
  List _feedBack = [];
  List get feedBack => _feedBack;
  Map _feedbackRecipient = {};
  Map get feedbackRecipient => _feedbackRecipient;
  List _feedBackArea = [];
  List get feedBackArea => _feedBackArea;
  addFeedback({
    required String feedback,
    required String receivingTeamId,
    required String receivingTeamName,
    required bool isAnonymous,
    required final context

    }) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LeaveFeedBackApi.addFeedback(
      token: value.getString('token') ?? '', 
      context: context,
      feedback: feedback,
      receivingTeamId: receivingTeamId,
      receivingTeamName: receivingTeamName,
      isAnonymous: isAnonymous
    );

     return data;
  }

  showFeedback({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LeaveFeedBackApi.showFeedbackList(
    token: value.getString('token') ?? '',context: context );
    _feedBack = data['data'];
    notifyListeners();
    return data;
  }

  showFeedbackRecipient({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LeaveFeedBackApi.leaveFeedBackRecipient(
    token: value.getString('token') ?? '', context: context);
    _feedbackRecipient = data['data'];
    notifyListeners();
    return data;
  }

  showFeedBackArea({required final context, required int areaId, required String date}) async{
    _feedBackArea.clear();
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LeaveFeedBackApi.feedbackCharts(
      token: value.getString('token') ?? '', 
      context: context,
      areaId: areaId,
      date: date
    );
    _feedBackArea = data['data'];
    notifyListeners();
    return data;
  }

}