
import 'api_paths.dart';
import 'dio_paths.dart';

class LeaveFeedBackApi {

  static Future <bool> addFeedback({
    required String token,
    required String feedback,
    required String receivingTeamName,
    required String receivingTeamId,
    required bool isAnonymous,
    required final context
  }) async{

    Map data = {
      "user_id" : 33,
      "club_id" : 1,
      "receiving_team" : receivingTeamName,
      "feedback" : feedback,
      "anonymous" : isAnonymous,
      "feedback_recipient_id": receivingTeamId
    };
    final response = await DioPaths.postMethod(
      path: ApiPaths.leaveFeedback, 
      context: context,
      data: data,
      token: token,
      errorType: 'Add Feedback'
    );

    return response.data['success'];
  }

  static Future <Map> showFeedbackList({required String token, required final context}) async{

    final response = await DioPaths.getMethod(
      path: ApiPaths.seeFeedback, 
      token: token,
      context: context,
      errorType: 'Show FeedBack'
    );
    
    return response.data;
  }

  static Future <Map> leaveFeedBackRecipient({required String token, required final context}) async{

    final response = await DioPaths.getMethod(
      path: ApiPaths.leaveFeedbackRecipient, 
      context: context,
      token: token,
      errorType: 'Show Recipient'
    );
    return response.data;
  }

  static Future <Map> feedbackCharts({
      required String token, 
      required final context,
      required int areaId,
      required String date
    }) async{
    final response = await DioPaths.getMethod(
      path: ApiPaths.feedbackArea(areaId, date), 
      context: context,
      token: token,
      errorType: 'Show feedback'
    );
    return response.data;
  }
}