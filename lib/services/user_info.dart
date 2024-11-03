import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mined/constants/api/terra.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api/user.dart';
import '../constants/save_local_storage.dart';

class UserInfo extends ChangeNotifier{
  Map _userInfo = {};
  Map get userInfo => _userInfo;

  Map _providers = {};
  Map get providers => _providers;

  List _userIndividuals = [];
  List get userIndividuals => _userIndividuals;

  Map _token = {};
  Map get token => _token;

  userData({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserApi.userData(token: value.getString('token') ?? '', context: context);
    _userInfo = data;
    notifyListeners();
    return _userInfo;
  }

  getUserIndividualsItem({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserApi.getUserIndividuals(token: value.getString('token') ?? '', context: context);
    log('Test: ${data.toString()}');
    _userIndividuals = data['data'];
    notifyListeners();
    return _userInfo;
  }


  showProviders(context) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await TerraApi.connectProviders(token: value.getString('token') ?? '', context: context);
    _providers = data;
    notifyListeners();
    return _providers;
  }

  getTerraToken(context) async{
    final data = await TerraApi.generateToken(devId: dotenv.env['DEV_ID']!,xApiKey: dotenv.env['X_API_KEY']! ,context: context);
    _token = data;
    notifyListeners();
    return _token;
  }


  userUpdateData({
    required String firstName,
    required String lastName,
    required String gender,
    required String mobileNumber,
    required final context

  }) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserApi.updateUserData(
      token: value.getString('token') ?? '',
      gender: gender, 
      mobileNumber: mobileNumber,
      lastName: lastName,
      firstName: firstName,
      context: context
    );
    _userInfo = data;
    notifyListeners();
    return _userInfo;
  }
}