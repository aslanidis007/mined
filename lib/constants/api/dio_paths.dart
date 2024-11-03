import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mined/authorization/login.dart';
import 'package:mined/routes/routes.dart';

class DioPaths{
  static Dio dio = Dio();

  //Post Api Method
  static postMethod({
    required String path, 
    required Map? data, 
    required String errorType,
    required String token,
    required final context
  }) async{
  try{
    final response = await dio.post(
        path,
        data: data,
        options: token == ''
        ? Options(
          headers: {
            "Accept": "application/json",
          }
        )
        : Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          }
        )
      );
      
      return response;
      
    } on DioException catch(error){
      if(error.response != null && 
          error.response!.statusCode == 422 ||
          error.response!.statusCode == 500 || error.response!.statusCode == 401){
            log('Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
            PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
            return error.response!;
      }else{
        return throw Exception('Critical Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
      }
    }
  }

  // Post method for terra
  static postMethodTerra({
    required String path, 
    required Map? data, 
    required String errorType,
    required String devId,
    required String xApiKey,
    required final context
  }) async{
  try{
    final response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'accept': 'application/json',
            'dev-id': devId,
            'content-type': 'application/json',
            'x-api-key': xApiKey
          }
        )
      );
      
      return response;
      
    } on DioException catch(error){
      if(error.response != null && 
          error.response!.statusCode == 422 ||
          error.response!.statusCode == 500 || error.response!.statusCode == 401){
            log('Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
            PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
            return error.response!;
      }else{
        return throw Exception('Critical Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
      }
    }
  }

  //Put Api Method
  static putMethod({
    required String path, 
    required String token,
    required final data, 
    required String errorType,
    required final context
  }) async{
    try{
      final response = await dio.put(
          path,
          data: data,
          options: token == ''
              ? Options(
              headers: {
                "Accept": "application/json",
                "Content-Type":"application/json",
              }
          )
              : Options(
              headers: {
                "Accept": "application/json",
                "Content-Type":"application/json",
                "Authorization": "Bearer $token",
              }
          )
      );
      return response;

    }on DioException catch(error){
      if(error.response != null &&
          error.response!.statusCode == 422 ||
          error.response!.statusCode == 500 || error.response!.statusCode == 401){
        log('Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
        // PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
        return error.response!.statusCode.toString();
      }else{
        return throw Exception('Critical Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
      }
    }
  }

    //Put Api Method
  static putMethodVideo({
    required String path, 
    required String token,
    required final data, 
    required String errorType,
    required final context
  }) async{
    try{
      final response = await dio.put(
          path,
          data: data,
          options: token == ''
              ? Options(
                contentType: 'video/mp4',
          )
              : Options(
              headers: {
                "Content-Type": "multipart/form-data",
                "Authorization": "Bearer $token",
              }
          ),
      );
      return response;

    }on DioException catch(error){
      if(error.response != null &&
          error.response!.statusCode == 422 ||
          error.response!.statusCode == 500 || error.response!.statusCode == 401){
        log('Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
        // PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
        return error.response!.statusCode.toString();
      }else{
        return throw Exception('Critical Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
      }
    }
  }
  //Delete Api Method
  static deleteMethod({
    required String path,
    required String token,
    required String errorType,
  }) async{
  try{
    final response = await dio.delete(
        path,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          }
        )
      );

      return response;
      
    } on DioException catch(error){
      if(error.response != null && 
          error.response!.statusCode == 422 ||
          error.response!.statusCode == 500 || error.response!.statusCode == 401){
            log('Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
            return error.response!.statusCode.toString();
      }else{
        return throw Exception('Critical Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
      }
    }
  }

  //Delete Api Method
  static deleteMethodWithData({
    required String path,
    required String token,
    required String errorType,
    required Map data,
  }) async{
    try{
      final response = await dio.delete(
          path,
          data: data,
          options: Options(
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer $token",
              }
          )
      );

      return response;

    } on DioException catch(error){
      if(error.response != null &&
          error.response!.statusCode == 422 ||
          error.response!.statusCode == 500 || error.response!.statusCode == 401){
        log('Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
        return error.response!.statusCode.toString();
      }else{
        return throw Exception('Critical Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
      }
    }
  }

    //Get Api Method
  static getMethod({
    required String path, 
    required String token,
    required String errorType,
    required final context
  }) async{
  try{
    final response = await dio.get(
        path,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          }
        )
      );

      return response;
      
    } on DioException catch(error){
      if(error.response != null && 
          error.response!.statusCode == 422 ||
          error.response!.statusCode == 500 || error.response!.statusCode == 401){
            log('Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
            PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
            return error.response!.statusCode.toString();
      }else{
        return throw Exception('Critical Error[$errorType] info: ${error.response!.data} status: ${error.response!.statusCode}');
      }
    }
  }
}