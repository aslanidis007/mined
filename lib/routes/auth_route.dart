import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mined/authorization/login.dart';
import 'package:mined/screens/intro/carousel.dart';
import 'package:mined/screens/intro/welcome.dart';
import 'package:mined/screens/menu/bottom_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api/start_up.dart';
import '../constants/save_local_storage.dart';

class AuthRoute{
  AuthRoute({required this.ctx});
  BuildContext? ctx;

  navigateController() async {
    SharedPreferences localStorageData = await SaveLocalStorage.pref;
    
    String token = localStorageData.getString('token') ?? '';
    bool isFirstTime = localStorageData.getBool('firstTime') ?? true;
    bool isShowCarousel = localStorageData.getBool('carousel') ?? true;

    if(token == ''){
      return const LoginPage();
    }else{
        if(isFirstTime){
          await localStorageData.setBool('firstTime',false);
            return const IntroPage();
        }else{
          if(isShowCarousel){
            await localStorageData.setBool('carousel', false);
            return const CarouselPage();
          }else{
            return const BottomMenu();
          }
        }
      }
      // if(data['data']['is_banned'] == 0){
      //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
      //     String currentAppVersion = packageInfo.version;
      //     List<String> parts = data['data']['latest_supported_version'].split('.');
      //     int versionNumber = int.tryParse(parts[0]) ?? 0;
      //   if(Version.parse(versionNumber.toString()) <= Version.parse(currentAppVersion)){
      //     if(isFirstTime){
      //       await localStorageData.setBool('firstTime',false);
      //       return const IntroPage();
      //     }else{
      //       if(isShowCarousel){
      //         await localStorageData.setBool('carousel', false);
      //         return const CarouselPage();
      //       }else{
      //         return const BottomMenu();
      //       }
      //     }
      //   }else{
      //     return const VersionAlert();
      //   }
      // }else{
      //   return const BannedAlert();
      // }
    }

  static sendStartUpInfo(String token, String? firebaseToken, String currentVersion, final context) async{

    final startupInfo = await putStartUpInfo(
      token: token,
      appVersion: currentVersion,
      device: Platform.isAndroid ? 'android' : 'ios',
      firebaseToken: firebaseToken,
      context: context
    );

    return startupInfo;
  }
}