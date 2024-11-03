import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/assets.dart';
import '../constants/color.dart';

TextStyle getTaskTextStyle(String taskType) {
  switch(taskType){
    case 'QUESTIONNAIRE':
    return const TextStyle(
      color: AppColors.orange,
      fontWeight: FontWeight.bold
    );
    case 'ACTIVITY':
    return const TextStyle(
      color: AppColors.green,
      fontWeight: FontWeight.bold
    );
    case 'SCREENING':
    return const TextStyle(
      color: AppColors.mov,
      fontWeight: FontWeight.bold
    );
    default:
    return const TextStyle(
      color: AppColors.mov,
      fontWeight: FontWeight.bold
    );
  }
}
Color getTaskBgStyle(String taskType) {
  switch(taskType){
    case 'QUESTIONNAIRE':
    return AppColors.bgTitleQna;
    case 'ACTIVITY':
    return AppColors.bgTitleAct;
    case 'SCREENING':
    return AppColors.bgTitleScreen;
    default:
    return AppColors.mov;
  }
}
Color getTaskBg(String taskType) {
  switch(taskType){
    case 'QUESTIONNAIRE':
    return AppColors.bgQna;
    case 'ACTIVITY':
    return AppColors.bgAct;
    case 'SCREENING':
    return AppColors.bgScreen;
    default:
    return AppColors.mov;
  }
}
Color getBorderColor(String taskType) {
  switch(taskType){
    case 'QUESTIONNAIRE':
    return AppColors.orange;
    case 'ACTIVITY':
    return AppColors.green;
    case 'SCREENING':
    return AppColors.mov;
    default:
    return AppColors.mov;
  }
}
SvgPicture getCategoryAvatar(String taskType) {
  switch(taskType){
    case 'QUESTIONNAIRE':
    return SvgPicture.asset(
      AppAssets.questAvatar,
    );
    case 'ACTIVITY':
    return SvgPicture.asset(
      AppAssets.activityAvatar,
    );
    case 'SCREENING':
    return SvgPicture.asset(
      AppAssets.screeningAvatar,
    );
    default:
    return SvgPicture.asset(
      AppAssets.questAvatar,
    );
  }
}