import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/assets.dart';
import '../../constants/color.dart';

class VersionAlert extends StatefulWidget {
  const VersionAlert({super.key});

  @override
  State<VersionAlert> createState() => _VersionAlertState();
}

class _VersionAlertState extends State<VersionAlert> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.update),
              const SizedBox(height: 30,),
              const Text(
                'You have an outdated version of the \napp. Click on the button below to \nupdated it to the latest version',
                style: TextStyle(
                    color: AppColors.darkMov,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: () => _launchPlayStore(),
                child: Container(
                  width: w * 0.8,
                  height: 50.0,
                  margin: const EdgeInsets.only(top: 30,),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    border: Border.all(color:AppColors.lightGreen)
                  ),
                  child: const Center(
                    child: Text(
                      'Update',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        color: AppColors.darkMov,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _launchPlayStore() async {
    String playStoreLink;
    Platform.isAndroid
     ? playStoreLink = 'https://play.google.com/store/apps/details?id=mined.app'
     : playStoreLink = 'https://apps.apple.com/in/app/mined/id1643018099';

    if (await canLaunch(playStoreLink)) {
      await launch(playStoreLink);
    } else {
      throw 'Could not launch $playStoreLink';
    }
  }
}