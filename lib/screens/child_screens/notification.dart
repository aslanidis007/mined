import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../helpers/notification_datetime.dart';
import '../../services/notification.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool shadowSelect = false;
  TextEditingController clubCodeController = TextEditingController();

  @override
  void initState() {
    Provider.of<PushNotification>(context, listen: false).fetchNotification(context: context);
    super.initState();
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
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(FontAwesomeIcons.angleLeft,color: AppColors.white, size: 30,)),
                       Expanded(
                        child: Text(
                          LocaleKeys.notificationTitle.tr(context: context),
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
          ),
           Expanded(
             child: Consumer<PushNotification>(
               builder: (context, data, child) {
                List notifyData = [];
                data.indexNotification.forEach((index, data) {
                  notifyData.add(data);
                });
                DateTime dateTime = DateTime.now();
                DateTime dateWithoutTime = DateTime(dateTime.year,dateTime.month,dateTime.day);  
                var todayList = notifyData.where((element) => dateWithoutTime.difference(DateTime.parse(element['created_at'])).inDays == 0).toList();
                var yesterdayList = notifyData.where((element) => dateWithoutTime.difference(DateTime.parse(element['created_at'])).inDays == 1).toList();
                var olderList = notifyData.where((element) => dateWithoutTime.difference(DateTime.parse(element['created_at'])).inDays > 1).toList();
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(todayList.isNotEmpty)...[
                        Text(
                          LocaleKeys.eventHistoryTodayTitle.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          for(var index = 0; index < todayList.length; index++)
                          clubLists(
                            w,
                            h,
                            notifyData[index]['title'],
                            notifyData[index]['created_at'],
                            notifyData[index]['id']
                          ),
                          Divider(color: AppColors.darkMov.withOpacity(0.3),),
                        ],
                        if(yesterdayList.isNotEmpty)...[
                        Text(
                          LocaleKeys.eventHistoryYesterdayTitle.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          for(var index = 0; index < yesterdayList.length; index++)
                          clubLists(
                            w,
                            h,
                            yesterdayList[index]['title'],
                            yesterdayList[index]['created_at'],
                            yesterdayList[index]['id']
                          ),
                          Divider(color: AppColors.darkMov.withOpacity(0.3),),
                        ],
                        if(olderList.isNotEmpty)...[
                        Text(
                          LocaleKeys.eventHistoryOlderTitle.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          for(var index = 0; index < olderList.length; index++)
                          clubLists(
                            w,
                            h,
                            olderList[index]['title'],
                            olderList[index]['created_at'],
                            olderList[index]['id']
                          )
                        ]
                      ],
                    ),
                  ),
                );
              }),
           ),
        ],
      ),
    );
  }
  Widget clubLists(double w, double h,String title, String date, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.circle, 
                size: 10, 
                color: Colors.red,
              ),
              const SizedBox(width: 10,),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 20,
                      blurRadius: 25,
                      offset: const Offset(0, 3), 
                    )
                  ]
                ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.darkMov,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.darkMov,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4.0,),
                  Text(
                    formatDateTime(DateTime.parse(date)),
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              const Spacer(),
                Expanded(
                child: InkWell(
                  onTap: () async{
                    await showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: false,
                      barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                      context: context,
                      builder: (context) => deleteMessage(w,h,id),
                    ); 
                  },
                  child: SvgPicture.asset(AppAssets.trash)
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
    Widget deleteMessage(double w, double h, String id) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.42,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                            'Are you sure you want to \ndelete this notification?',
                            style: TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () async{
                              await Provider.of<PushNotification>(context, listen: false).deletePushNotification(id);
                              await Provider.of<PushNotification>(context, listen: false).fetchNotification(context: context);
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
                              child: const Center(
                                child: Text(
                                  'Yes',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'No',
                            style: TextStyle(
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
    Widget buildSheetName(double w, var h) => Padding(
      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.57,
            padding: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter activation code',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        'This code should have been provided to you by \nyour club. If you don’t have this now, or want to \nadd more clubs, you can do it in later in \nSettings. ',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: w * 0.8,
                        margin: EdgeInsets.only(top: h * 0.035, bottom: h * 0.025),
                        decoration: BoxDecoration(                 
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.transparent),
                            boxShadow: shadowSelect == false 
                            ? null 
                            :[
                              BoxShadow(
                                color: AppColors.darkMov.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 20,
                                offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          onTap: (){
                            setState(() {
                              shadowSelect = !shadowSelect;
                            });
                          },
                          controller: clubCodeController,
                          style: const TextStyle(
                            color: AppColors.darkMov
                          ),
                          cursorColor: AppColors.darkMov,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.lightMov
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.darkMov
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            hintText: 'Club activation code',
                            hintStyle: const TextStyle(
                              color: AppColors.lightMov
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () async{
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
                              child: const Center(
                                child: Text(
                                  'Submit code',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
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