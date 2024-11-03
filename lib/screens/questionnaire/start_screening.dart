import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/routes/screening_route.dart';
import 'package:mined/screens/menu/bottom_menu.dart';
import 'package:mined/services/save_variables.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../routes/routes.dart';
import '../../services/user_tasks.dart';

class StartScreening extends StatelessWidget {
  const StartScreening({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<SaveVariables>(
        builder: (context, data, child) {
          return Column(
            children: [
              Container(
                width: w,
                height: h * 0.18,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(85),
                    bottomLeft: Radius.circular(20)
                  ),
                  color: AppColors.mov,
                  image: DecorationImage(
                    repeat: ImageRepeat.repeat,
                    opacity: .25,
                    image: AssetImage(AppAssets.loginBackgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 65.0, left: 30.0, right: 30.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              PageNavigator(ctx: context).nextPageOnly(page: const BottomMenu());
                            },
                            child: const Icon(FontAwesomeIcons.angleLeft,color: AppColors.white, size: 30,)),
                          Expanded(
                            child: Text(
                              data.variable[0]['title'],
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children:[
                    Text(
                      data.variable[0]['name'],
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0,),
                    Text(
                        data.variable[0]['description'],
                        style: const TextStyle(
                        color: AppColors.lightMov,
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30.0,),
                    Text(
                      '${data.variable[0]['number_of_items'] ?? 0}',
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.clock, size: 18, color: AppColors.lightMov,),
                        const SizedBox(width: 10,),
                        Text(
                          '${data.variable[0]['estimated_duration'] ?? 0} minutes',
                          style: const TextStyle(
                            color: AppColors.lightMov,
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
               Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: (){
                      ScreeningRoute(ctx: context).viewScreenType(type: Provider.of<Tasks>(context, listen:false).taskItem['task_item_type']);
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
                        'Start',
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
              )
            ],
          );
        }
      ),
     );
  }
}