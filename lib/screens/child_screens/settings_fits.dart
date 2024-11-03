import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mined/constants/assets.dart';
import 'package:mined/screens/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/alert.dart';
import '../../constants/api/terra.dart';
import '../../constants/color.dart';
import '../../constants/save_local_storage.dart';
import '../../services/user_info.dart';

class SettingsFits extends StatefulWidget {
  const SettingsFits({super.key});

  @override
  State<SettingsFits> createState() => _SettingsFitsState();
}

class _SettingsFitsState extends State<SettingsFits> {
  @override
  void initState() {
    Provider.of<UserInfo>(context, listen: false).showProviders(context);
    super.initState();
  }

  callSdk(context) async{
    await Provider.of<UserInfo>(context, listen: false).showProviders(context);
  }

  callTerra() async{
    Map result =  await TerraApi.terraConnection(devId: dotenv.env['DEV_ID']!, context: context, xApiKey: dotenv.env['X_API_KEY']!);
    if(result['status'] == 'success'){
      launchUrl(
          Uri.parse(result['url']),
          mode: LaunchMode.externalApplication
      );
    }else{
      // ignore: use_build_context_synchronously
      showMessage(message: 'something went wrong!', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FutureBuilder<bool>(
        future: isSamsungDevice(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
          }else if(snapshot.hasError){
            return const Text('...');
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SpeedDial(
              label: const Text('Add werables'),
              animatedIcon: AnimatedIcons.menu_close,
              buttonSize: const Size(50,50),
              backgroundColor: AppColors.mov,
              children: [
                if(snapshot.data == false)...[
                  SpeedDialChild(
                    onTap: () async => await callSdk(context),
                    child: SvgPicture.asset(AppAssets.union),
                    label: snapshot.data == true ? 'Samsung Health' : 'Apple Health',
                  ),
                ],
                SpeedDialChild(
                  onTap: () async => await callTerra(),
                  child: SvgPicture.asset(AppAssets.union),
                  label: 'More Wearables'
                ),
              ],
            ),
          );
        }
      ),
      body: SizedBox(
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Widgets.header(context,w,h,'My Wearables'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'My Wearables',
                      style: TextStyle(
                          fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkMov
                      ),
                    ),
                  ),
                  Consumer<UserInfo>(
                    builder: (context, prov,child) {
                      if(prov.providers.isEmpty){
                        return Container();
                      }
                      return SizedBox(
                        width: 350,
                        height: 300,
                        child: ListView.builder(
                          itemCount: prov.providers['data']['providers'].length,
                          itemBuilder: (context, index) {
                            String image = '';
                            switch (prov.providers['data']['providers'][index]){
                              case 'GOOGLE':
                                image = AppAssets.googlefit;
                                break;
                              case 'SAMSUNG':
                                image = AppAssets.fitbit;
                                break;
                              case 'FITBIT':
                                image = AppAssets.fitbit;
                                break;
                            }
                            return activateFits(w,h,prov.providers['data']['providers'][index],image);
                          }
                        ),
                      );
                    }
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> isSamsungDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    bool isSamsung = false;
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        log(androidInfo.manufacturer.toString());
        if (androidInfo.manufacturer.toLowerCase() == 'samsung') {
          isSamsung = true;
        }
      }
    } catch (e) {
      log('Error: $e');
    }
    
    return isSamsung;
  }

  Widget activateFits(double w, double h,String title,String img){
    return Container(
      width: w * 0.8,
      margin: const EdgeInsets.only(top: 5.0,bottom: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
              color: AppColors.darkMov.withOpacity(0.25),
              spreadRadius: 2.5,
              blurRadius: 25,
              offset: const Offset(0, 1),
          ),
        ]
      ),
      child: ListTile(
          minLeadingWidth : 0,
          leading: SvgPicture.asset(img),
        title: Transform.translate(
          offset: const Offset(-5,0),
          child: Text(
              title,
            style: const TextStyle(
              color: AppColors.darkMov,
              fontWeight: FontWeight.bold,
              fontSize: 14.0
            ),
          ),
        ),
        trailing: GestureDetector(
          onTap: () async{
            SharedPreferences value = await SaveLocalStorage.pref;
            await TerraApi.deleteProvider(context: context, provider: title, token: value.getString('token') ?? '');
            await Provider.of<UserInfo>(context, listen: false).showProviders(context);
          },
          child: Container(
            width: 100,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGreen, width: 1.5),
              borderRadius: BorderRadius.circular(50)
            ),
            child: const Center(
              child: Text(
                'Disconnect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.darkMov,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}