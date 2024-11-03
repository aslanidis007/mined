import 'package:mined/constants/api/api_paths.dart';
import 'package:mined/constants/api/dio_paths.dart';
import 'package:mined/services/auth_system.dart';

class TerraApi{

  static Future <Map> connectProviders({
    required  context,
    required String token,
  }) async{
    final response = await DioPaths.getMethod(
        path: ApiPaths.fetchProviders,
        context: context,
        errorType: 'error terra request',
        token: token
    );
    return response.data;
  }

  static Future <Map> deleteProvider({
    required  context,
    required String provider,
    required String token,
  }) async{
    Map data = {
      'provider':provider
    };
    final response = await DioPaths.deleteMethodWithData(
        path: ApiPaths.deleteProvider,
        data: data,
        errorType: 'error terra request',
        token: token,
    );
    return response.data;
  }

  static Future <Map> generateToken({
    required String devId,
    required  context,
    required String xApiKey,
  }) async{
    final response = await DioPaths.postMethodTerra(
      path: ApiPaths.generatetoken,
      data: {},
      errorType: 'error terra request',
      context: context,
      devId: devId,
      xApiKey: xApiKey
    );

    return response.data;
  }


  static Future <Map> terraConnection({
    required String devId,
    required  context,
    required String xApiKey,
  }) async{
    String refId = await AuthSystem().getId();
    Map data = {
      'providers': 'GARMIN,WITHINGS,FITBIT,GOOGLE,OURA,WAHOO,PELOTON,ZWIFT,TRAININGPEAKS,FREESTYLELIBRE,DEXCOM,COROS,HUAWEI,OMRON,RENPHO,POLAR,SUUNTO,EIGHT,APPLE,CONCEPT2,WHOOP,IFIT,TEMPO,CRONOMETER,FATSECRET,NUTRACHECK,UNDERARMOUR',
      'language': 'en',
      'use_terra_avengers_app': false,
      'reference_id': refId,
    };
    final response = await DioPaths.postMethodTerra(
      path: ApiPaths.terraApi, 
      xApiKey: xApiKey,
      devId: devId,
      context: context,
      data: data,
      errorType: 'error terra request'
    );
    return response.data;
  }
}