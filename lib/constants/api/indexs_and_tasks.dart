import 'api_paths.dart';
import 'dio_paths.dart';

class IndexesAndTasksApi{

  static Future <Map> indexesData({required String token, required final context}) async{
      final response = await DioPaths.getMethod(
        path: ApiPaths.indexes,
        context: context,
        token: token,
        errorType: 'task indexes'
      );
      
      return  response.data;
  }
}