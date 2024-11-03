
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/constants/assets.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/questionnaire/start_screening.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import '../../routes/screening_route.dart';
import '../../services/user_tasks.dart';
import '../menu/bottom_menu.dart';

class Information extends StatelessWidget {
  final String btnName, title, text, taskType;
  const Information({super.key,required this.btnName,required this.title, required this.text, required this.taskType});

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
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0, bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      PageNavigator(ctx: context).nextPageOnly(page: const StartScreening());
                    },
                    child: const Icon(
                      Icons.close, 
                      size: 38, 
                      color: AppColors.lightMov,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(FontAwesomeIcons.clock, color: AppColors.lightMov, size: 18,),
                      SizedBox(width: 10,),
                      Text(
                        '2 min',
                        style: TextStyle(
                          color: AppColors.lightMov
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: w,
                height: h * 0.88,
                padding: EdgeInsets.only(top: h * 0.11),
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
                          text,
                          style: const TextStyle(
                            color: AppColors.lightMov,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0,),
                        if(taskType == 'END_INFORMATION')...[
                          if(Provider.of<Tasks>(context, listen: false).summary['show_help_button'] == true)...[
                            GestureDetector(
                              onTap: () async{
                                await Provider.of<Tasks>(context, listen: false).completeTask(
                                  assignedTaskId: Provider.of<Tasks>(context, listen: false).taskItem['assigned_task_id'],
                                  context: context
                                );
                                PageNavigator(ctx: context).nextPageOnly(page: const BottomMenu());
                              },
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Need help? ',
                                      style: TextStyle(
                                        color: AppColors.orange,
                                        fontSize: 14
                                      )
                                    ),
                                    TextSpan(
                                      text: '  Tap here',
                                      style: TextStyle(
                                        color: AppColors.darkMov,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                      )
                                    )
                                  ]
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20.0,),
                          HtmlWidget(Provider.of<Tasks>(context, listen: false).summary['text']),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  ScreeningRoute(ctx: context).completeTaskAndCheckNextStep(type: taskType,context: context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
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
              top: 45,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                AppAssets.qIcon,
                width: 90,
                height: 114,
              ),
            ),
          ],
        ),
      )
    );
  }
}