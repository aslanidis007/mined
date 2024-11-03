import 'api_paths.dart';
import 'dio_paths.dart';

class NotificationApi{
  static Future <Map> indexNotification({
    required String token,
    required final context
  }) async{

    final response = await DioPaths.getMethod(
      path: ApiPaths.notification, 
      token: token,
      context: context,
      errorType: 'notification indexes'
    );
    return response.data;
  }

  static Future <Map> deleteNotification({
    required String token,
    required String notificationId,
  }) async{
      final response = await DioPaths.deleteMethod(
        path: ApiPaths.deleteNotification(notificationId), 
        token: token,
        errorType: 'delete notification'
      );

      return response.data;
  }

  static Future <Map> sendFirebaseToken({
    required String token,
    required String? firebaseToken,
    required final context
  }) async{

    Map data = {
      'token': firebaseToken
    };

      final response = await DioPaths.postMethod(
        data: data,
        path: ApiPaths.sendFirebasetoken, 
        token: token,
        context: context,
        errorType: 'send firebase token'
      );

      return response.data;
  }
}