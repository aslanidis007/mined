import 'package:flutter/material.dart';
import 'package:mined/constants/api/life_event.dart';
import 'package:mined/constants/save_local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifeEvent extends ChangeNotifier{
  List _lifeEvent = [];
  List get lifeEvent => _lifeEvent;
  List _lifeEventType = [];
  List get lifeEventType => _lifeEventType;
  bool? _success;
  bool? get success => _success;

  addLifeEvent({required int? type, required String startDate, String? endDate, String? title, String? note, required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LifeEventApi.addLifeEvent(
      token: value.getString('token') ?? '',
      context: context, 
      type: type, 
      note: note,
      title: title,
      endDate: endDate,
      startDate: startDate
    );

    return data;
  }

  showLifeEvent({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LifeEventApi.showLifeEvent(
      token: value.getString('token') ?? '', 
      context: context
    );
    _lifeEvent = data['data'];
    _success = data['success'];
    notifyListeners();
  }
  showLifeEventType({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LifeEventApi.showLifeEventType(
      token: value.getString('token') ?? '',
      context: context
    );
    _lifeEventType = data['data'];
    _success = data['success'];
    notifyListeners();
  }

  deleteLifeEvent({required String lifeEventId}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await LifeEventApi.deleteLifeEvent(
      eventId: lifeEventId,
      token: value.getString('token') ?? '', 
    );

    return data;
  }
}