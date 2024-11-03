
import 'package:mined/constants/api/api_paths.dart';
import 'package:mined/constants/api/dio_paths.dart';

class ResetChangePasswordApi{

  static Future <Map> changePassowrd({
    required String oldPassword, 
    required String newPassword,
    required String token,
    required final context
    }
    ) async{

      Map data = {
        'old_password':oldPassword,
        'new_password':newPassword
      };
      final response = await DioPaths.putMethod(
        path: ApiPaths.changePassword,
        token: token,
        data:data, 
        errorType: 'change password',
        context: context
      );

      return  response.data;
  }

  static Future <String> resetPassowrd({
    required String email,
    required final context
    }) async{

      Map data = {
        'email':email,
      };
      final response = await DioPaths.postMethod(
        path: ApiPaths.resetPassword, 
        token: '',
        data: data, 
        context: context,
        errorType: 'reset password'
      );

      return  response.statusCode.toString();
  }
}