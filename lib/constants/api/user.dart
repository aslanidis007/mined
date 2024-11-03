import 'api_paths.dart';
import 'dio_paths.dart';

class UserApi{

  static Future <Map> userData({required String token, required final context}) async{
    final response = await DioPaths.getMethod(
      path: ApiPaths.user,
      context: context,
      token: token,
      errorType: 'user data'
    );
    
    return  response.data['data'];
  }

  static Future <Map> getUserIndividuals({required String token, required final context}) async{
    final response = await DioPaths.getMethod(
      path: ApiPaths.getUserIndividuals,
      context: context,
      token: token,
      errorType: 'user data'
    );
    
    return  response.data;
  }

  static Future <Map> userDelete({required String token}) async{
    final response = await DioPaths.deleteMethod(
      path: ApiPaths.user,
      token: token,
      errorType: 'delete user'
    );
    
    return  response.data['data'];
  }
  static Future <Map> updateUserData({
    required String token,
    required String gender,
    required String mobileNumber,
    required String firstName,
    required String lastName,
    required final context
  }) async{
    Map data = {
      "gender" : gender,
      "phone_number" : mobileNumber,
      "first_name" : firstName,
      "last_name" : lastName,
    };
    final response = await DioPaths.putMethod(
      path: ApiPaths.updateUser,
      token: token,
      errorType: 'update profile',
      data: data,
      context: context
    );
    
    return  response.data;
  }
}