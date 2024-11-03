import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/color.dart';
import '../../routes/routes.dart';

Widget burgerMenu(String title, String image, double w, Widget page, BuildContext context){
  return GestureDetector(
    onTap: (){
      PageNavigator(ctx: context).nextPage(page: page);
    },
    child: ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      contentPadding: EdgeInsets.only(left: w * 0.05),
      minLeadingWidth: 0,
      leading: SvgPicture.asset(image),
      trailing: title != 'Alerts'
          ? null
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        width: 30,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.orange),
            color: AppColors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20)
        ),
        child: const Text(
          '1',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w500,
              fontSize: 14
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.darkMov,
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
      ),
    ),
  );
}