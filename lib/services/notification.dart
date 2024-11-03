import 'package:flutter/material.dart';
import 'package:mined/constants/api/notification.dart';
import 'package:mined/helpers/request_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/save_local_storage.dart';

class PushNotification extends ChangeNotifier{
  Map _indexNotification = {};
  Map get indexNotification => _indexNotification;

  fetchNotification({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await NotificationApi.indexNotification(token: value.getString('token') ?? '', context: context);
    _indexNotification = data['data'];
    notifyListeners();
    return data;
  }

  deletePushNotification(String id,) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await NotificationApi.deleteNotification(token: value.getString('token') ?? '',notificationId: id);
    return isRequestSuccess(data);
  }

  sendToken(String? firebaseToken, final context) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await NotificationApi.sendFirebaseToken(token: value.getString('token') ?? '',firebaseToken: firebaseToken, context: context);
    return isRequestSuccess(data);
  }
}