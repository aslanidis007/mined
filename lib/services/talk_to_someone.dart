import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api/talk_to_someone.dart';
import '../constants/save_local_storage.dart';

class TalkToSomeone extends ChangeNotifier{
  List _medicalList = [];
  List get medicalList => _medicalList;
  
  addTalkToSomeone({required String refereeId,required String refereeClubId, required String referralReason, required String medicalId, required bool isAnonymous, required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await TalkToSomeoneApi.addTalkToSomeone(
      token: value.getString('token') ?? '',
      context: context, 
      refereeId: refereeId,
      refereeClubId: refereeClubId,
      referralReason: referralReason,
      medicalId: medicalId,
      isAnonymous: isAnonymous
    );
     return data;
  }

  showMedical({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await TalkToSomeoneApi.showMedicalList(
    token: value.getString('token') ?? '', context: context);
    _medicalList = data['data'];
    notifyListeners();
    return data;
  }
}