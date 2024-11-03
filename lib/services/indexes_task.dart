import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api/indexs_and_tasks.dart';
import '../constants/save_local_storage.dart';

class IndexesAndTasks extends ChangeNotifier{
  Map _indexData = {};
  Map get indexData => _indexData;
  
  indexesList({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await IndexesAndTasksApi.indexesData(token: value.getString('token') ?? '', context: context);
    _indexData = data['data'];
    notifyListeners();
    return data;
  }
}