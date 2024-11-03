
import 'package:mined/constants/api/api_paths.dart';
import 'package:mined/constants/api/dio_paths.dart';

class LoginRegisterApi{
  
  static Future <Map> emailLoginAuth({
    required String email, 
    required String password,
    required final context
  }) async{
      Map data = {
        'email':email,
        'password':password,
        'device_name':"mobile_app"
      };
      
    final response = await DioPaths.postMethod(
      path: ApiPaths.emailLogin, 
      data: data, 
      context: context,
      token:'',
      errorType: 'login'
    );
    return response.data;
  }


  static Future <Map> socialLogin({
    required String? email, 
    required String? socialId,
    required String? accessToken,
    required String? firstName,
    required String? lastName,
    required final context
  }) async{

      Map data = {
        'email':email,
        'social_id':socialId,
        'access_token':accessToken,
        'provider':'google',
        'pin':'1234',
        'first_name':firstName,
        'last_name':lastName,
      };

    final response = await DioPaths.postMethod(
      path: ApiPaths.socialLogin, 
      data: data, 
      context: context,
      token:'',
      errorType: 'social login'
    );
    
    return response.data;
  }

  
  static Future <Map> emailRegister({
    required String email,
    required String password, 
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required String dob,
    required final context
  }) async{

      Map data = {
        'email':email,
        'password':password,
        'first_name':firstName,
        'last_name':lastName,
        'phone_number':phoneNumber,
        'dob':dob,
        'gender':gender
      };

      final response = await DioPaths.postMethod(
        path: ApiPaths.emailRegister, 
        data: data, 
        context: context,
        token: '',
        errorType: 'register'
      );

      return response.data;
  }
}