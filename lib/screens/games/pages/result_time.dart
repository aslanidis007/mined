import 'package:flutter/material.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/games/pages/summary.dart';
import 'package:mined/screens/games/service/round_counter.dart';
import 'package:provider/provider.dart';
import '../../../constants/color.dart';
import '../../../services/user_tasks.dart';

class ResultTime extends StatelessWidget {
  final RoundCounter prov;
  const ResultTime({super.key, required this.prov});

  completeTaskItemAndCheckForNextStep(context, Map completeAnswer)async{
    await Provider.of<Tasks>(context, listen: false).completeTaskItem(
      assignedTaskItemId: Provider.of<Tasks>(context, listen: false).taskItem['id'], 
      taskList: completeAnswer,
      context: context
    );
    await Provider.of<Tasks>(context, listen: false).fetchSummaryData(
      assignedTaskId: Provider.of<Tasks>(context, listen: false).taskItem['assigned_task_id'],
      context: context,
    );
      await Provider.of<Tasks>(context, listen: false).completeTask(
        assignedTaskId: Provider.of<Tasks>(context, listen: false).taskItem['assigned_task_id'],
        context: context,
      );
      PageNavigator(ctx: context).nextPageOnly(page: const TaskSummary(
        btnName: 'Back to home',
        hasNextStep: false,
      ));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Visibility(
      visible: prov.endgame,
      child: Positioned(
        child: Container(
          width: w,
          height: h,
          color: AppColors.veryDarkMov.withOpacity(0.9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your reaction time',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.white
                ),
              ),
              const SizedBox(height: 10.0,),
              Text(
                '${prov.timeAverage.toStringAsFixed(3)} s',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.yellow
                ),
              ),
              const SizedBox(height: 25.0,),
              GestureDetector(
                onTap: () async{
                  await completeTaskItemAndCheckForNextStep(context, prov.responses);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: w * 0.8,
                  decoration:  BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightGreen.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 3)
                      )
                    ]
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}