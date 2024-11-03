import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/functions/notification_status.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/child_screens/privacy.dart';
import 'package:mined/screens/child_screens/terms.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/header.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List selected = [false,false];
  bool? isEnable;
  String currentAppVersion = '';
  TextStyle fontStyle = const TextStyle(
    color: AppColors.darkMov,
    fontSize: 14,
    fontWeight: FontWeight.w700
  );

  isNotificationEnable() async{
    isEnable = await resultNotificationStatus();
    setState(() {});
  }

  setAppVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() => currentAppVersion = packageInfo.version);
  }

  @override
  void initState() {
    setAppVersion();
    isNotificationEnable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    context.locale == const Locale('en') ? selected[0] = true : selected[1] = true;
    return Scaffold(
      body: Column(
        children: [
          Widgets.header(context,w,h,LocaleKeys.settingsTitle.tr(context: context)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: [
                InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: false,
                      barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (BuildContext context, setState) => deleteMessage(w,h,setState)
                      ),
                    ); 
                  },
                  child: ListTile(
                    minLeadingWidth:5,
                    leading: SvgPicture.asset(
                      AppAssets.language
                    ),
                    title: Text(
                      LocaleKeys.language.tr(context: context),
                      style: fontStyle,
                    ),
                    trailing: RichText(
                      text: TextSpan(
                        text: context.locale == const Locale('en')
                         ? 'English (UK) \t\t\t\t'
                         : 'Ελληνικά (GR) \t\t\t\t',
                        style: const TextStyle(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500
                        ),
                        children: const [
                          WidgetSpan(
                            child: Icon(
                              FontAwesomeIcons.chevronRight, 
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
                InkWell(
                  onTap: (){
                    PageNavigator(ctx: context).nextPage(page: const Privacy());
                  },
                  child: ListTile(
                    minLeadingWidth:5,
                    leading: SvgPicture.asset(
                      AppAssets.privacy
                    ),
                    title: Text(
                      LocaleKeys.privacyPolicyTitle.tr(context: context),
                      style: fontStyle,
                    ),
                    trailing: const Icon(FontAwesomeIcons.chevronRight, size: 15,),
                  ),
                ),
                InkWell(
                  onTap: (){
                    PageNavigator(ctx: context).nextPage(page: const Terms());
                  },
                  child: ListTile(
                    minLeadingWidth:5,
                    leading: SvgPicture.asset(
                      AppAssets.terms
                    ),
                    title: Text(
                      LocaleKeys.termsAndConditions.tr(context: context),
                      style: fontStyle,
                    ),
                    trailing: const Icon(FontAwesomeIcons.chevronRight, size: 15,),
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    if(isEnable != true){
                      final result = await notifyPermission(context);
                      if(result){
                        await isNotificationEnable();
                      }
                    }else{
                      AppSettings.openAppSettings(type: AppSettingsType.notification);
                      await isNotificationEnable();
                    }
                  },
                  child: ListTile(
                    minLeadingWidth:5,
                    leading: const Icon(
                      Icons.notifications_active_outlined, 
                      color: AppColors.darkMov,
                      size: 24,
                    ),
                    title: Text(
                      LocaleKeys.notification.tr(context: context),
                      style: fontStyle,
                    ),
                    trailing: isEnable == true
                    ? const Icon(Icons.circle, size: 18, color: AppColors.green,)
                    : const Icon(Icons.circle, size: 18, color: AppColors.orange,)
                  ),
                ),
                ListTile(
                  minLeadingWidth:5,
                  leading: SvgPicture.asset(
                    AppAssets.version
                  ),
                  title: Text(
                    LocaleKeys.version.tr(context: context),
                    style: fontStyle,
                  ),
                  trailing: Text(
                    currentAppVersion,
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
    Widget deleteMessage(double w, double h, setState) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.45,
            padding: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: ListTile(
                          onTap: (){
                          setState(() {
                              selected[0] = true;
                              selected[1] = false;
                            }); 
                          },
                          title: Text(
                            'English (UK)',
                            style: TextStyle(
                              fontSize: 14,
                              color: selected[0] == true
                              ? AppColors.darkMov
                              : AppColors.darkGrey,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          trailing: selected[0] == true
                          ? const Icon(Icons.circle, color: AppColors.darkMov,)
                          : Icon(Icons.circle_outlined, color: AppColors.darkGrey.withOpacity(0.6),)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: ListTile(
                          onTap: (){
                           setState(() {
                            selected[1] = true;
                            selected[0] = false;
                            });  
                          },
                          title: Text(
                            'Ελληνικά (GR)',
                            style: TextStyle(
                              fontSize: 14,
                              color: selected[1] == true
                              ? AppColors.darkMov
                              : AppColors.darkGrey,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          trailing: selected[1] == true
                          ? const Icon(Icons.circle, color: AppColors.darkMov,)
                          : Icon(Icons.circle_outlined, color: AppColors.darkGrey.withOpacity(0.6),)
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () async{
                              Navigator.pop(context);
                            },
                            child: InkWell(
                              onTap: () async{
                                if(selected[0] == true){
                                  await context.setLocale(const Locale('en'));
                                }else{
                                  await context.setLocale(const Locale('el'));
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: w * 0.8,
                                height: 50.0,
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  color:AppColors.lightGreen,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.lightGreen.withOpacity(0.6),
                                      spreadRadius: 3,
                                      blurRadius: 20,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                ),
                                child: Center(
                                  child: Text(
                                    LocaleKeys.language.tr(context: context),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            LocaleKeys.cancelSettings.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.lightMov,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
             Positioned(
              top: 25,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow color
                      blurRadius: 25, // Spread of the shadow
                      offset: const Offset(0, 4), // Offset of the shadow
                    ),
                  ],                 
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppColors.darkMov,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
}