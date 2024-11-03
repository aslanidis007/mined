import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/menu/bottom_menu.dart';
import 'package:mined/screens/questionnaire/information.dart';
import 'package:mined/screens/questionnaire/start_questionnaire.dart';
import 'package:provider/provider.dart';

import '../screens/questionnaire/complete_questionnaire.dart';
import '../services/selection_list.dart';
import '../services/selection_mechanism.dart';
import '../services/user_tasks.dart';

class ScreeningRoute{
  ScreeningRoute({this.ctx});
  BuildContext? ctx;

  viewScreenType({required String type}) async {
    log(type);
    switch(type){
      case 'INFORMATION':
        PageNavigator(ctx: ctx).nextPageOnly(page: Information(
          btnName: 'Next', 
          title: 'Information', 
          text: Provider.of<Tasks>(ctx!,listen: false).taskItem['text'].toString(),
          taskType: 'INFORMATION',
          )
        );
        break;
      case 'END_INFORMATION':
        await Provider.of<Tasks>(ctx!, listen: false).fetchSummaryData(context: ctx, assignedTaskId: Provider.of<Tasks>(ctx!, listen: false).taskItem['assigned_task_id']);
        PageNavigator(ctx: ctx).nextPageOnly(page: Information(
          btnName: 'Back to home', 
          title: 'Information', 
          text: Provider.of<Tasks>(ctx!,listen: false).taskItem['text'].toString(),
          taskType: 'END_INFORMATION',
          )
        );
        break;
      case 'QUESTIONNAIRE':
        await Provider.of<ResponseModel>(ctx!, listen: false).resetResponses();
        await Provider.of<AnswerSelection>(ctx!, listen: false).resetChoose();
        PageNavigator(ctx: ctx).nextPageOnly(page: const StartQuestionnaire(taskType: null,));
        break;
      default:
        PageNavigator(ctx: ctx).nextPageOnly(page: const BottomMenu());
        break;
    }
  }
  viewNextScreen({required bool hasNext}) async{
    log(hasNext.toString());
    switch(hasNext){
      case true:
        PageNavigator(ctx: ctx).replaceNextPage(page: const CompleteQuestionnaire(
          btnName: 'Next', 
          title: 'Thanks for completing the \nquestionnaire.',
          description: 'Your score will be factored in the relevant indexes.',
          hasNextStep: true,
          )
        );
        break;
      case false:
        await Provider.of<Tasks>(ctx!, listen: false).fetchSummaryData(context: ctx, assignedTaskId: Provider.of<Tasks>(ctx!, listen: false).taskItem['assigned_task_id']);
        PageNavigator(ctx: ctx).replaceNextPage(page: const CompleteQuestionnaire(
          btnName: 'Back to home', 
          title: 'Thank you for taking the \nquestionnaire.',
          description: 'Press the button below to continue',
          hasNextStep: false,
          )
        );
        break;
      default:
        PageNavigator(ctx: ctx).nextPageOnly(page: const BottomMenu());
        break;
    }
  }

  completeTaskAndCheckNextStep({required String type, required final context}) async{
    log(type.toString());
    switch(type){
      case 'END_INFORMATION':
        await Provider.of<Tasks>(ctx!, listen: false).completeTask(
          assignedTaskId: Provider.of<Tasks>(ctx!, listen: false).taskItem['assigned_task_id'],
          context: ctx
        );
        PageNavigator(ctx: ctx).nextPageOnly(page: const BottomMenu());
        break;
      case 'INFORMATION':
       final complete = await Provider.of<Tasks>(ctx!, listen: false).completeTaskItem(
          assignedTaskItemId: Provider.of<Tasks>(ctx!, listen: false).taskItem['id'],
          context: ctx,
          taskList: {}
        );
        if(complete['next_step'] == true){
          final result = await Provider.of<Tasks>(ctx!,listen: false).fetchTaskItem(
            assignedTaskId: Provider.of<Tasks>(ctx!, listen: false).taskItem['assigned_task_id'], context: context);
          if(result.isNotEmpty){
            await ScreeningRoute(ctx: ctx).viewScreenType(type: result['task_item_type']);
          }
        }else{
          PageNavigator(ctx: ctx).nextPageOnly(page: const BottomMenu());
        }
        break;
      default:
        PageNavigator(ctx: ctx).nextPageOnly(page: const BottomMenu());
        break;
    }
  }

  checkNextStep({required bool hasNextStep, required final context}) async{
    log(hasNextStep.toString());
    switch(hasNextStep){
      case false:
        await Provider.of<Tasks>(ctx!, listen: false).completeTask(
          assignedTaskId: Provider.of<Tasks>(ctx!, listen: false).taskItem['assigned_task_id'],
          context: ctx
        );
        PageNavigator(ctx: ctx).nextPageOnly(page: const BottomMenu());
        break;
      case true:
        final result = await Provider.of<Tasks>(ctx!,listen: false).fetchTaskItem(
          assignedTaskId: Provider.of<Tasks>(ctx!, listen: false).taskItem['assigned_task_id'], context: context);
        if(result.isNotEmpty){
          await ScreeningRoute(ctx: ctx).viewScreenType(type: result['task_item_type']);
        }
    }
  }
}