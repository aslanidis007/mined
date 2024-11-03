import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api/reset_change_password_api.dart';
import '../constants/save_local_storage.dart';

class ResetChangePassword extends ChangeNotifier{
  
  resetService({required String email, required final context}) async{
    final data = await ResetChangePasswordApi.resetPassowrd(email:email,context: context);
    return data;
  }
  changeUserPassword({required String oldPassowrd, required String newPassword, required context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await ResetChangePasswordApi.changePassowrd(token:  value.getString('token') ?? '', oldPassword: oldPassowrd, newPassword: newPassword,context: context);
    return data;
  }
}