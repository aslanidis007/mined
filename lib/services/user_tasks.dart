import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mined/constants/api/user_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/save_local_storage.dart';

class Tasks extends ChangeNotifier{
  List _tasks = [];
  List get tasks => _tasks;

  List _selfTasks = [];
  List get selfTasks => _selfTasks;

  Map _selfTasksInfo = {};
  Map get selfTasksInfo => _selfTasksInfo;

  Map _taskItem = {};
  Map get taskItem => _taskItem;

  Map _summary = {};
  Map get summary => _summary;
  
  taskList({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.fetchTasks(token: value.getString('token') ?? '', context: context);
    _tasks = data['data'];
    notifyListeners();
    return data;
  }

  selfTaskList({required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.fetchSelfTasks(token: value.getString('token') ?? '', context: context);
    _selfTasks = data['data'];
    notifyListeners();
    return data;
  }

  selfTaskSendItem({required final context,required String taskType, required int taskId, required String individualId}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.sendSelfTaskItem(token: value.getString('token') ?? '', context: context, taskId: taskId, taskType: taskType, individualId: individualId );
    log(data['data'].toString());
    notifyListeners();
    return data['data'];
  }

  selfTaskInfoList({required final context, required String taskType, required int taskId}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.fetchSelfTaskInfo(token: value.getString('token') ?? '', context: context, taskId: taskId, taskType: taskType);
    _selfTasksInfo = data['data'];
    notifyListeners();
    return data;
  }

  startTaskItemList({required String assignedTaskId, required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.startTaskItem(token: value.getString('token') ?? '',assignedTaskId: assignedTaskId, context: context);
    return data['data'];
  }

  fetchTaskItem({required String assignedTaskId, required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.fetchTaskItem(token: value.getString('token') ?? '',assignedTaskId: assignedTaskId, context: context);
    _taskItem = data['data'];
    notifyListeners();
    return data['data'];
  }

  fetchSummaryData({required String assignedTaskId, required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.fetchSummary(token: value.getString('token') ?? '',assignedTaskId: assignedTaskId, context: context);
    _summary = data['data'];
    notifyListeners();
    return data['data'];
  }

  completeTaskItem({required String assignedTaskItemId, required Map taskList, required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.completeTaskItem(token: value.getString('token') ?? '',assignedTaskItemId: assignedTaskItemId,dataList: taskList, context: context);
    return data['data'];
  }

  completeTask({required String assignedTaskId,required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.completeTask(token: value.getString('token') ?? '',assignedTaskId: assignedTaskId,context: context);

    return data['data'];
  }

  videoUrl({required String assignedTaskItemId,required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.videoUrlTask(token: value.getString('token') ?? '',assignedTaskItemId: assignedTaskItemId,context: context);
    
    return data['data'];
  }

  uploadVideo({required String url,required final context, required String videoPath}) async{
    final data = await UserTasks.uploadVideoTask(url: url,context: context,videoPath: videoPath);
    return data;
  }

  completeVideo({required String assignedTaskItemId,required final context}) async{
    SharedPreferences value = await SaveLocalStorage.pref;
    final data = await UserTasks.completeVideoTask(token: value.getString('token') ?? '',assignedTaskItemId: assignedTaskItemId,context: context);

    return data['data'];
  }
}