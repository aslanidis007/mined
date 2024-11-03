import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/constants/assets.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/menu/bottom_menu.dart';
import 'package:mined/screens/questionnaire/questionnaire.dart';
import 'package:mined/screens/questionnaire/start_screening.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import '../../services/user_tasks.dart';

class StartQuestionnaire extends StatelessWidget {
  final String? taskType;
  const StartQuestionnaire({super.key, required this.taskType});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white.withOpacity(0.95),
      body: Consumer<Tasks>(
        builder: (context, data, child) {
          if(data.taskItem.isEmpty){
            return const SizedBox();
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0, bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        if(taskType == null){
                          PageNavigator(ctx: context).nextPageOnly(page: const StartScreening());

                        }else if(taskType == 'QUESTIONNAIRE'){
                          PageNavigator(ctx: context).nextPageOnly(page: const BottomMenu());
                          
                        }
                      },
                      child: const Icon(
                        Icons.close, 
                        size: 38, 
                        color: AppColors.lightMov,
                      ),
                    ),
                    Row(
                      children:[
                        const Icon(FontAwesomeIcons.clock, color: AppColors.lightMov, size: 18,),
                        const SizedBox(width: 10,),
                        Text(
                          '${data.taskItem['task']['estimated_duration']} min',
                          style: const TextStyle(
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
                  padding: EdgeInsets.only(top: h * 0.11,left: 20,right: 20),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)
                    )
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Questionnaire',
                        style: TextStyle(
                          color: AppColors.mov,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        '${data.taskItem['task']['name']}',
                        style: const TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      Text(
                        '${data.taskItem['task']['description']}',
                        style: const TextStyle(
                          color: AppColors.lightMov,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // const SizedBox(height: 25.0,),
                      // const Text(
                      //   'Sleeping disorder can feel like',
                      //   style: TextStyle(
                      //     color: AppColors.darkMov,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 12.0,),
                      // const Text(
                      //   'Sit non mattis faucibus tellus. Fringilla quis \nsapien id suspendisse nunc id est.',
                      //   style: TextStyle(
                      //     color: AppColors.lightMov,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 20.0,),
                      // const Text(
                      //   'Ac nulla iaculis sit scelerisque in suspendisse nec \ndiam at. Pulvinar ut erat risus nibh elementum \nmassa consectetur quis malesuada. Amet nunc \nfacilisi massa venenatis mattis pulvinar.',
                      //   style: TextStyle(
                      //     color: AppColors.lightMov,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: (){
                    PageNavigator(ctx: context).nextPage(page: const Questionnaire());
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
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
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
          );
        }
      )
    );
  }
}