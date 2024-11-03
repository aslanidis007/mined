
import 'package:flutter/material.dart';
import '../constants/color.dart';

Widget listByDate({
  required double w,
  required double h,
  required List todayList,
  required List yesterdayList,
  required List olderList,
  required List isExpandedToday,
  required List isExpandedYesterday,
  required List isExpandedOlder,
  required Widget Function(String title) feedbackTitleToday,
  required Widget Function(String title) feedbackTitleYesterday,
  required Widget Function(String title) feedbackTitleOlder,
  required Widget Function(List feedBack, int index, List expanded) feedbackListToday,
  required Widget Function(List feedBack, int index, List expanded) feedbackListYesterday,
  required Widget Function(List feedBack, int index, List expanded) feedbackListOlder,
}) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 30.0),
  width: w,
  height: h,
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        if(todayList.isNotEmpty)...[
          feedbackTitleToday('Today'),
          const SizedBox(height: 10.0,),
          for(var index = 0; index < todayList.length; index++)
          feedbackListToday(todayList,index,isExpandedToday)
        ],
        const SizedBox(height: 10,),
        todayList.isNotEmpty
        ? Divider(color: AppColors.darkMov.withOpacity(0.3),)
        : const SizedBox(),
        const SizedBox(height: 10,),
        if(yesterdayList.isNotEmpty)...[
          feedbackTitleYesterday('Yesterday'),
          const SizedBox(height: 10.0,),
          for(var index = 0; index < yesterdayList.length; index++)
          feedbackListYesterday(yesterdayList,index,isExpandedYesterday)
        ],
        const SizedBox(height: 10,),
        yesterdayList.isNotEmpty
        ? Divider(color: AppColors.darkMov.withOpacity(0.3),)
        : const SizedBox(),
        const SizedBox(height: 10,),
        if(olderList.isNotEmpty)...[
          feedbackTitleOlder('Older'),
          const SizedBox(height: 10.0,),
          for(var index = 0; index < olderList.length; index++)
          feedbackListOlder(olderList,index,isExpandedOlder)
        ],
        olderList.isNotEmpty
        ? Divider(color: AppColors.darkMov.withOpacity(0.3),)
        : const SizedBox(),
        const SizedBox(height: 50,)
      ],
    ),
  )
);