
import 'package:mined/constants/api/api_paths.dart';
import 'package:mined/constants/api/dio_paths.dart';

class LifeEventApi{
  // Loguut user account from app
  static Future <String> addLifeEvent({
    required String token,
    required int? type,
    required String startDate,
    required String? endDate,
    String? title,
    String? note,
    required final context
  }) async{

    Map data = title == null
    ?{
      "type" : type,
      "start_date" : startDate,
      "associated_club_id" : 12,
      "end_date" : endDate ?? '',
      "notes" : note ?? ''
    }
    : {
      "type" : type,
      "start_date" : startDate,
      "title": title,
      "associated_club_id" : 12,
      "end_date" : endDate ?? '',
      "notes" : note ?? ''
    };

    final response = await DioPaths.postMethod(
      path: ApiPaths.addLifeEvent, 
      data: data,
      token: token,
      context: context,
      errorType: 'Add Life Event'
    );

    
    
    return response.statusCode.toString();
  }

  static Future <Map> showLifeEvent({
    required String token,
    required final context
  }) async{

    final response = await DioPaths.getMethod(
      path: ApiPaths.lifeEventHistory, 
      token: token,
      context: context,
      errorType: 'Show Life Event'
    );
    return response.data;
  }
  static Future <Map> showLifeEventType({
    required String token,
    required final context
  }) async{

    final response = await DioPaths.getMethod(
      path: ApiPaths.lifeEventType, 
      token: token,
      context: context,
      errorType: 'Show Life Event Type'
    );
    return response.data;
  }

  static Future <String> deleteLifeEvent({
    required String token,
    required String eventId,
  }) async{

    final response = await DioPaths.deleteMethod(
      path: ApiPaths.lifeEventById(eventId), 
      token: token,
      errorType: 'Delete Life Event'
    );
    return response.statusCode.toString();
  }
}