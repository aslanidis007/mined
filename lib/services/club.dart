import 'package:flutter/material.dart';
import 'package:mined/constants/api/club.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/save_local_storage.dart';
import '../helpers/request_success.dart';

class ClubProvider extends ChangeNotifier{
  List _clubs = [];
  List get clubs => _clubs;
  List status = [];
  
  clubList({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await ClubApi.showclub(token: value.getString('token') ?? '',context: context);
    final isSuccess = isRequestSuccess(data);
    isSuccess ? _clubs = data['data'] : _clubs = [];
    notifyListeners();
    return _clubs;
  }
  addClub({required String clubId, final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await ClubApi.addClub(token: value.getString('token') ?? '',clubId: clubId,context: context);
    return isRequestSuccess(data);
  }
  deleteClub({required String clubId, final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await ClubApi.deleteClub(token: value.getString('token') ?? '',clubId: clubId);
    return isRequestSuccess(data);
  }
}