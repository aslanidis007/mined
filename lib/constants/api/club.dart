import 'api_paths.dart';
import 'dio_paths.dart';

class ClubApi{

  static Future <Map> showclub({required String token, required final context}) async{
    final response = await DioPaths.getMethod(
        path: ApiPaths.club,
        context: context,
        token: token,
        errorType: 'fetch club'
    );
    return response.data;
  }

  static Future <Map> deleteClub({required String token,required String clubId}) async{
    final response = await DioPaths.deleteMethod(
        path: ApiPaths.clubDelete(clubId),
        token: token,
        errorType: 'delete club'
    );

    return response.data;
  }

  static Future <Map> addClub({required String token, required String clubId, required final context}) async{
    Map data = {"activation_code" : clubId};
    final response = await DioPaths.postMethod(
        context: context,
        data: data,
        path: ApiPaths.club,
        token: token,
        errorType: 'add club'
    );

    return response.data;
  }
}