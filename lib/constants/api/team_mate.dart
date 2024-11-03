import 'api_paths.dart';
import 'dio_paths.dart';

class TeamMateApi {

  static Future <Map> showTeamMate({required String token, required final context}) async{

    final response = await DioPaths.getMethod(
        path: ApiPaths.teammate,
        context: context,
        token: token,
        errorType: 'Team mate'
    );

    return response.data;
  }
  
  static Future <Map> showMedicalContact({required String token,required String user, required final context}) async{

    final response = await DioPaths.getMethod(
        path: ApiPaths.medicalContactByUser(user),
        context: context,
        token: token,
        errorType: 'Team mate medical contact'
    );

    return response.data;
  }

  static Future <Map> showReferral({required String token, required final context}) async{

    final response = await DioPaths.getMethod(
        path: ApiPaths.referral,
        context: context,
        token: token,
        errorType: 'Team mate Referral'
    );

    return response.data;
    
  }
}