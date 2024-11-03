import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../record_face.dart/face_detector_page.dart';
import '../record_face.dart/start_record/start_record.dart';
import '../routes/routes.dart';
import '../screens/games/numbers_by_series.dart';
import '../screens/games/pages/start_game.dart';
import '../screens/games/random_position_circles.dart';
import '../screens/games/remember_numbers.dart';
import '../screens/games/select_ shapes.dart';
import '../screens/questionnaire/start_questionnaire.dart';
import '../screens/questionnaire/start_screening.dart';
import '../services/save_variables.dart';
import '../services/selection_list.dart';
import '../services/selection_mechanism.dart';
import '../services/user_tasks.dart';

startScreeningOrQuestionnaire({
  required BuildContext context,
  required String assignedTaskId,
  required String title, 
  required String name, 
  required String description,
  required String scientificName,
  required String taskType,
  String? numberOfItems,
  required String estimatedDuration,
  required String slug
}) async{
    Map result = await Provider.of<Tasks>(context,listen: false).startTaskItemList(assignedTaskId: assignedTaskId,context: context);
    Provider.of<AnswerSelection>(context, listen: false).resetChoose();
    Provider.of<ResponseModel>(context, listen: false).resetResponses();
    if(taskType == 'SCREENING'){
      if(result.isNotEmpty){
        Map fetchTaskItem = await Provider.of<Tasks>(context,listen: false).fetchTaskItem(assignedTaskId: assignedTaskId, context: context);
        if(fetchTaskItem.isNotEmpty){
          log('Start Screening');
          await Provider.of<SaveVariables>(context, listen: false).setValue(
              {
                'title': title,
                'name': name,
                'description': description,
                'scientific_name': scientificName,
                'number_of_items': numberOfItems,
                'estimated_duration': estimatedDuration
              }
          );
          PageNavigator(ctx: context).nextPageOnly(page: const StartScreening());
        }else{
          log('fetch task item list is empty');
        }
      }
    }else if(taskType == 'QUESTIONNAIRE'){
      if(result.isNotEmpty){
        Map fetchTaskItem = await Provider.of<Tasks>(context,listen: false).fetchTaskItem(assignedTaskId: assignedTaskId,context: context);
        if(fetchTaskItem.isNotEmpty){
          log('Start Questionnaire');
          PageNavigator(ctx: context).nextPageOnly(page: StartQuestionnaire(taskType: taskType,));
        }else{
          log('fetch task item list is empty');
        }
      }
    } else if (taskType == 'ACTIVITY'){
      Map fetchTaskItem = await Provider.of<Tasks>(context,listen: false).fetchTaskItem(assignedTaskId: assignedTaskId,context: context);
      if(fetchTaskItem.isNotEmpty){
        log('Start Activity');
        switch(slug){
          case 'timed-concentration-test':
            PageNavigator(ctx: context).nextPageOnly(page: StartGame(page: NumberBySeries(title: name,body: description),title: name,body: description,));
            break;
          case 'digit-span-number-test':
            PageNavigator(ctx: context).nextPageOnly(page: StartGame(page: RememberNumber(title: name,body: description,), title: name,body: description));
            break;
          case 'shape-selector-test':
            PageNavigator(ctx: context).nextPageOnly(page: StartGame(page: SelectShapes(title: name,body: description,),title: name,body: description));
            break;
          case 'reaction-time-test':
            PageNavigator(ctx: context).nextPageOnly(page: StartGame(page: RandomPositionCircles(title: name,body: description), title: name,body: description));
            break;
          case 'eye-saccades-test':
            PageNavigator(ctx: context).nextPageOnly(page: StartRecord(page: const FaceDetectorPage(),title: name,body: description));
            break;
          default:
            log('Something went wrong');
            break;
        }

      }else{
        log('fetch task item list is empty');
      }
    }
  }