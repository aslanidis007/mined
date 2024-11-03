import 'package:mined/constants/api/api_paths.dart';
import 'package:mined/constants/api/dio_paths.dart';

class LogOutDeleteApi{
  // Loguut user account from app
  static Future <String> logout({
    required String token, 
    required final context
  }) async{

    final response = await DioPaths.postMethod(
      path: ApiPaths.logout, 
      data: null,
      token: token,
      context: context,
      errorType: 'logout'
    );

    return response.statusCode.toString();
  }
  //Delete permantly user account
  static Future <String> deleteAccount({
    required String token,
  }) async{
      final response = await DioPaths.deleteMethod(
        path: ApiPaths.deleteAccount, 
        token: token,
        errorType: 'delete account'
      );

      return response.statusCode.toString();
  }
}