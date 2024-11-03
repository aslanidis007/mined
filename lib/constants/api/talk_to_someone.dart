import 'api_paths.dart';
import 'dio_paths.dart';

class TalkToSomeoneApi {

  static Future <String> addTalkToSomeone({
    required String token,
    required String refereeId,
    required String refereeClubId, 
    required String referralReason, 
    required String medicalId,
    required bool isAnonymous,
    required final context
  }) async{

    Map data = {
      "referee_id" : refereeId,
      "referee_club_id" : refereeClubId,
      "referral_reason" : referralReason,
      "medical_contact_id" : medicalId,
      "anonymous": isAnonymous
    };
    final response = await DioPaths.postMethod(
      path: ApiPaths.referral, 
      context: context,
      data: data,
      token: token,
      errorType: 'Referral talk to someone'
    );

    
    
    return response.statusCode.toString();
  }

  static Future <Map> showMedicalList({required String token, required final context}) async{

    final response = await DioPaths.getMethod(
      path: ApiPaths.medicalContact,
      context: context, 
      token: token,
      errorType: 'Referral talk to someone'
    );
    
    return response.data;
  }
}