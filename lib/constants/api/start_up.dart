  
import 'api_paths.dart';
import 'dio_paths.dart';

Future <Map> putStartUpInfo({
    required String token,
    required String device,
    required String appVersion,
    required String? firebaseToken,
    required final context
  }) async{
    
    Map data = {
      "user_token": token,
      "firebase_token" : firebaseToken,
      "app_version" : appVersion,
      "os" : device
    };

    final response = await DioPaths.putMethod(
      path: ApiPaths.checkIn, 
      token: token,
      errorType: 'put start up info',
      data: data,
      context: context
    );
    return response.data;
  }