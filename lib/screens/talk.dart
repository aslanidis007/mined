import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mined/constants/save_local_storage.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/child_screens/reach_out_to_someone.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/assets.dart';
import '../constants/color.dart';
import '../services/delete_logout_acc.dart';


class Talk extends StatefulWidget {
  const Talk({super.key});

  @override
  State<Talk> createState() => _TalkState();
}

class _TalkState extends State<Talk> {
  DeleteLogoutAccount logout = DeleteLogoutAccount();
  
  callImmediateHelp() async{
    SharedPreferences localStorageData = await SaveLocalStorage.pref;
    final number = localStorageData.getString('immediate_help_number');
    final Uri url = Uri(
      scheme: 'tel',
      path: '$number'
    );
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }else{
      log('cannot launch this url');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
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
                  Text(
                    LocaleKeys.talkToSomeOneTitle.tr(context: context),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async{
                  await callImmediateHelp();
                },
                child: Container(
                  width: w,
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.green, width: 1.2),
                    borderRadius: const BorderRadius.all(Radius.circular(40))
                  ),
                  child: Text(
                    LocaleKeys.immediateHelpTitle.tr(context: context),
                    style: const TextStyle(
                      color: AppColors.darkMov,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 15.0,),
              Text(
                LocaleKeys.immediateHelpDescription.tr(context: context),
                style: const TextStyle(
                  color: AppColors.lightMov,
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35.0,),

              Text(
                LocaleKeys.or.tr(context: context),
                style: const TextStyle(
                  color: AppColors.darkMov,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35.0,),
              InkWell(
                onTap: (){
                  PageNavigator(ctx: context).nextPage(page: const ReachOutToSomeone());
                },
                child: Container(
                  width: w,
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.green, width: 1.2),
                    borderRadius: const BorderRadius.all(Radius.circular(40))
                  ),
                  child: Text(
                  LocaleKeys.reachOutToSomeoneTitle.tr(context: context),
                    style: const TextStyle(
                      color: AppColors.darkMov,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 15.0,),
              Text(
                LocaleKeys.reachOutToSomeoneDescription.tr(context: context),
                style: const TextStyle(
                  color: AppColors.lightMov,
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      )
    );
  }
}