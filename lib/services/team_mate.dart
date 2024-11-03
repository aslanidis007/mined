import 'package:flutter/material.dart';
import 'package:mined/constants/api/team_mate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/save_local_storage.dart';

class TeamMateProvider extends ChangeNotifier{
  List _teamMateData = [];
  List get teamMateData => _teamMateData;
  List _medical = [];
  List get medical => _medical;
  List _referral = [];
  List get referral => _referral;

  teamMateList({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await TeamMateApi.showTeamMate(token: value.getString('token') ?? '', context: context);
    _teamMateData = data['data'];
    notifyListeners();
    return data;
  }
  teamMateMedical({required String user, required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await TeamMateApi.showMedicalContact(token: value.getString('token') ?? '',user: user, context: context);
    _medical = data['data'];
    notifyListeners();
    return data;
  }
  teamMateReferral({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await TeamMateApi.showReferral(token: value.getString('token') ?? '', context: context);
    _referral = data['data'];
    notifyListeners();
    return data;
  }
}