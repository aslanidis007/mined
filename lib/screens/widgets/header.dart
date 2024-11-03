import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';

class Widgets{

static Widget header(BuildContext context, double w, double h, String title){
    return Container(
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
                    Navigator.pop(context);
                  },
                  child: const Icon(FontAwesomeIcons.angleLeft,color: AppColors.white, size: 30,)),
                Expanded(
                  child: Text(
                    title,
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
    );
  }
}