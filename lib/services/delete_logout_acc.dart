import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mined/authorization/login.dart';
import 'package:mined/constants/alert.dart';
import 'package:mined/constants/api/logout_delete_api.dart';
import 'package:mined/constants/save_local_storage.dart';
import 'package:mined/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api/api_paths.dart';
import 'auth_system.dart';
import 'hide_nav_bar.dart';

class DeleteLogoutAccount extends ChangeNotifier{

  logoutService(context) async{
    AuthSystem auth = AuthSystem();
    SharedPreferences localStorageData = await SaveLocalStorage.pref;
    final data = await LogOutDeleteApi.logout(token: await auth.getToken(), context: context);
    if (data == '200'){
      await localStorageData.remove('token');
      await localStorageData.remove('userId');
      if(ApiPaths.googleSignInAndroid.currentUser != null || ApiPaths.googleSignInIos.currentUser != null){
        if (Platform.isAndroid) {
          await ApiPaths.logoutAndroid();
        } else {
          await ApiPaths.logoutApple();
        }
      }

      await Provider.of<HideNavBar>(context, listen: false).isVisible();
      PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
    }else{
      showMessage(context: context, message: 'Δεν υπάρχει σύνδεση στο διαδίκτυο');
    }
  }

  deleteAccountService(context) async{
    AuthSystem auth = AuthSystem();
    SharedPreferences localStorageData = await SaveLocalStorage.pref;
    final data = await LogOutDeleteApi.deleteAccount(token: await auth.getToken());

    if (data == '200'){
      await localStorageData.remove('token');
      PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
    }else{
      showMessage(context: context, message: 'Δεν υπάρχει σύνδεση στο διαδίκτυο');
    }
  }
}