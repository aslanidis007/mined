import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mined/constants/assets.dart';
import 'package:mined/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../constants/color.dart';
import '../../screens/games/pages/summary.dart';
import '../../services/user_tasks.dart';

class EndRecord extends StatelessWidget {
  final String btnName, title, description, videoPath;
  const EndRecord({super.key,required this.btnName,required this.title, required this.description, required this.videoPath});

  completeTaskItemAndCheckForNextStep(context)async{
    int statusCode;
    await Provider.of<Tasks>(context, listen: false).completeTaskItem(
      assignedTaskItemId: Provider.of<Tasks>(context, listen: false).taskItem['id'], 
      taskList: {},
      context: context
    );
      Map data = await Provider.of<Tasks>(context, listen: false).videoUrl(
        assignedTaskItemId: Provider.of<Tasks>(context, listen: false).taskItem['id'],
        context: context,
      );
      if(data.isNotEmpty){
        statusCode = await Provider.of<Tasks>(context, listen: false).uploadVideo(
          url: data['url'],
          context: context,
          videoPath: videoPath
        );
        if(statusCode == 200){
          await Provider.of<Tasks>(context, listen: false).completeVideo(
            assignedTaskItemId: Provider.of<Tasks>(context, listen: false).taskItem['id'],
            context: context,
          );
          await Provider.of<Tasks>(context, listen: false).completeTask(
            assignedTaskId: Provider.of<Tasks>(context, listen: false).taskItem['assigned_task_id'],
            context: context,
          );

          await Provider.of<Tasks>(context, listen: false).fetchSummaryData(
            assignedTaskId: Provider.of<Tasks>(context, listen: false).taskItem['assigned_task_id'],
            context: context,
          );
        }
      }
  }


  Future<void> sendRequest(BuildContext context) async {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return  AlertDialog(
          backgroundColor: AppColors.mov,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
          ),
          scrollable: true,
          contentPadding: const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 20.0, right: 20.0),
          content: const Column(
            children: [
              Text(
                "This may take a few moments. Please wait while we are processing your data....",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white
                ),
              ),
              SizedBox(height: 12.0,),
              LinearProgressIndicator(color: AppColors.white, backgroundColor: AppColors.darkMov,),
            ],
          ),
        );
      },
    );
    try {
      WakelockPlus.disable();
      await completeTaskItemAndCheckForNextStep(context);
      Navigator.pop(context);
      PageNavigator(ctx: context).nextPageOnly(page: const TaskSummary(
        btnName: 'Back to home',
        hasNextStep: false,
      ));
    } catch (e) {
      Navigator.pop(context); // Close the dialog in case of error
      print("Error during conversion: $e");
      // Optionally, show an error dialog here
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white.withOpacity(0.95),
      body: SizedBox(
        width: w,
        height: h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: w,
                height: h * 0.88,
                padding: EdgeInsets.only(top: h * 0.21),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)
                  )
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 200),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 24,
                            fontWeight: FontWeight.w700
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15.0,),
                        Text(
                          description,
                          style: const TextStyle(
                            color: AppColors.lightMov,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: (){
                  sendRequest(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: w * 0.8,
                  decoration:  BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightGreen.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 10,
                        offset: const Offset(0, 3)
                      )
                    ]
                  ),
                  child: Text(
                    btnName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                AppAssets.star,
                width: 100,
                height: 190,
              ),
            ),
          ],
        ),
      )
    );
  }
}