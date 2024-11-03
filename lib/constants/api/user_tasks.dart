import 'dart:io';
import 'api_paths.dart';
import 'dio_paths.dart';

class UserTasks{


  static Future <Map> fetchTasks({required String token, required final context}) async{

    final response = await DioPaths.getMethod(
        path: ApiPaths.tasks,
        context: context,
        token: token,
        errorType: 'User Tasks'
    );

    return response.data;
  }

  static Future <Map> startTaskItem({required String token, required String assignedTaskId, required final context}) async{

    final response = await DioPaths.putMethod(
        path: ApiPaths.startTaskItem(assignedTaskId),
        token: token,
        errorType: 'User Start Tasks Item', 
        data: {},
        context: context
    );

    return response.data;
  }

    static Future <Map> fetchSummary({required String token, required String assignedTaskId, required final context}) async{

    final response = await DioPaths.putMethod(
        path: ApiPaths.summary(assignedTaskId),
        token: token,
        errorType: 'User Start Tasks Item', 
        data: {},
        context: context
    );

    return response.data;
  }

  static Future <Map> fetchTaskItem({required String token, required String assignedTaskId, required final context}) async{

    final response = await DioPaths.getMethod(
        path: ApiPaths.tasksItem(assignedTaskId),
        token: token,
        context: context,
        errorType: 'User Fetch Tasks Item', 
    );

    return response.data;
  }

  static completeTaskItem({required String token, required String assignedTaskItemId, required Map dataList, required final context}) async{
    
    Map dataListNew = {'responses': dataList};

    final response = await DioPaths.putMethod(
        path: ApiPaths.completeTasksItem(assignedTaskItemId),
        token: token,
        errorType: 'User Complete Tasks Item', 
        data: dataListNew,
        context: context

    );

    return response.data;
  }

  static fetchSelfTasks({required String token, required final context}) async{
    
    final response = await DioPaths.getMethod(
        path: ApiPaths.selfTasks,
        token: token,
        errorType: 'Get self Tasks', 
        context: context

    );

    return response.data;
  }
  static sendSelfTaskItem({required String token, required final context, required String taskType, required taskId, required String individualId }) async{

    Map body = {
      "task_type" : taskType, //"QUESTIONNAIRE", "SCREENING"
      "task_id" : taskId, 
      if (individualId != '') "individual_id" : individualId
    };
    
    final response = await DioPaths.postMethod(
        path: ApiPaths.postSelfTasks,
        token: token,
        data: body,
        errorType: 'send self Tasks', 
        context: context

    );

    return response.data;
  }

  static fetchSelfTaskInfo({required String token, required final context, required String taskType, required int taskId}) async{

    Map body = {
      "task_type" : taskType,
      "task_id" : taskId
    };
    
    final response = await DioPaths.postMethod(
        path: ApiPaths.selfTaskInfo,
        token: token,
        data: body,
        errorType: 'fetch self Tasks info', 
        context: context

    );

    return response.data;
  }



  static completeTask({required String token, required String assignedTaskId, required final context}) async{

    final response = await DioPaths.putMethod(
        path: ApiPaths.completeTasks(assignedTaskId),
        token: token,
        errorType: 'User Complete Tasks', 
        data: {},
        context: context
    );

    return response.data;
  }
  static videoUrlTask({required String token, required String assignedTaskItemId, required final context}) async{
    
    final response = await DioPaths.postMethod(
        path: ApiPaths.videoUrl(assignedTaskItemId),
        token: token,
        errorType: 'User Send Video Tasks', 
        data: null,
        context: context
    );

    return response.data;
  }

  static uploadVideoTask({required String url, required final context, required String videoPath}) async{
    final file = File(videoPath);

    final response = await DioPaths.putMethodVideo(
        path: url,
        token: '',
        errorType: 'User Send Video Tasks',
        data: await file.readAsBytes(),
        context: context
    );
    return response.statusCode;
  }

  static completeVideoTask({required String token, required String assignedTaskItemId, required final context}) async{

    final response = await DioPaths.putMethod(
        path: ApiPaths.completeVideo(assignedTaskItemId),
        token: token,
        errorType: 'User Complete Video Tasks', 
        data: {},
        context: context
    );

    return response.data;
  }
}