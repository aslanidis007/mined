import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mined/constants/assets.dart';
import 'package:provider/provider.dart';
import '../../../constants/color.dart';
import '../../../routes/routes.dart';
import '../../../services/user_tasks.dart';
import '../../menu/bottom_menu.dart';


class TaskSummary extends StatelessWidget {
  final String btnName;
  final bool hasNextStep;
  
  const TaskSummary({super.key, required this.btnName, required this.hasNextStep});

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
                        HtmlWidget(Provider.of<Tasks>(context, listen: false).summary['text']),
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
                onTap: () {
                  PageNavigator(ctx: context).nextPageOnly(page: const BottomMenu());
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: w * 0.8,
                  decoration: BoxDecoration(
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