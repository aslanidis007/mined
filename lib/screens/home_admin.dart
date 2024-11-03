import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/child_screens/my_clubs.dart';
import 'package:mined/screens/child_screens/my_profile.dart';
import 'package:mined/services/hide_nav_bar.dart';
import 'package:provider/provider.dart';
import '../constants/assets.dart';
import '../constants/color.dart';
import '../services/delete_logout_acc.dart';
import '../services/user_tasks.dart';
import '../translations/locale_keys.g.dart';
import 'child_screens/notification.dart';
import 'child_screens/settings.dart';
import 'menu/burger_menu.dart';
import 'widgets/athleteList.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> with SingleTickerProviderStateMixin{
  bool containerSize = false;
  AnimationController? _animationController;
  bool _isVisible = false;
  String lang = 'en';
  final ScrollController _scrollController = ScrollController();
  int itemSelected = -1;
  List<String> tags = [];
  List<String> options = ['Graduation', 'Loss', 'Child birth', 'Injury', 'Raise'];

  bool isOptionSelected(String option) {
    return tags.contains(option);
  }
  
  void toggleOption(String option) {
    setState(() {
      if (isOptionSelected(option)) {
        tags.remove(option);
      } else {
        tags.add(option);
      }
    });
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500), // Adjust the duration as needed
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Provider.of<IndexesAndTasks>(context, listen: false).indexesList(context: context);
    Provider.of<Tasks>(context, listen: false).taskList(context: context);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  whenBottomNavBarIsHide(context) async{
    await _toggleContainerVisibility();
    await Provider.of<HideNavBar>(context, listen: false).isHide();
  }
  whenBottomNavBarIsVisible(context) async{
    await _toggleContainerVisibility();
    await Provider.of<HideNavBar>(context, listen: false).isVisible();
  }

  _toggleContainerVisibility(){
    setState(() {
      _isVisible = !_isVisible;
      if (_isVisible) {
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    });
  }

  refreshData() async{
    await Provider.of<Tasks>(context, listen: false).taskList(context: context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshData();
        },
        child: Stack(
          children: [
            SizedBox(
              width: w,
              height: h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: w,
                          height: h * 0.225,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(30)),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:  [
                                    InkWell(
                                        onTap: () async {
                                          await whenBottomNavBarIsHide(context);
                                        },
                                        child: SvgPicture.asset(
                                          AppAssets.menu, height: 25,
                                        )
                                    ),
                                    SvgPicture.asset(AppAssets.logoVertical, height: 60),
                                    InkWell(
                                        onTap: () async {
                                          PageNavigator(ctx: context).nextPage(page: const NotificationPage());
                                        },
                                        child: SvgPicture.asset(AppAssets.bell, height: 30)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100,),
                    SvgPicture.asset(AppAssets.adminLayer),
                    const SizedBox(height: 25.0,),
                    const Text(
                      'Your athletes missing a phone?',
                      style: TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0,),
                    const Text(
                      'Save the day - lend them yours to \nfinish their tests!',
                      style: TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: h / 16,),
                    GestureDetector(
                      onTap: () async{
                        await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (BuildContext context, setState) => const AthleteList()
                          ),
                        ); 
                      },
                      child: Container(
                        width: w * 0.9,
                        height: 60.0,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 40.0),
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
                            'Start a task',
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
                  ],
                ),
              ),
            ),
              Positioned(
                top: 0,
                bottom: 0,
                left: _isVisible ? 0 : -240, // Adjust the offset to hide the container
                child: GestureDetector(
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(_animationController!),
                    child: Container(
                        width: w,
                        color: Colors.grey[200],
                        child: Stack(
                          children: [
                            Container(
                              width: w,
                              height: 120,
                              decoration: const BoxDecoration(
                                  color: AppColors.mov,
                                  image: DecorationImage(
                                    repeat: ImageRepeat.repeat,
                                    opacity: .25,
                                    image: AssetImage(AppAssets.loginBackgroundImage),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(80),
                                  )
                              ),
                            ),
                            Positioned(
                              top: 35,
                              left: 20,
                              child: GestureDetector(
                                onTap: () async{
                                  await whenBottomNavBarIsVisible(context);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 40,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            Positioned(
                                top: 80,
                                left: 0,
                                right: 0,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.white,
                                          width: 5.0
                                      )
                                  ),
                                  child: const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(AppAssets.loginBackgroundImage),
                                  ),
                                )
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 130),
                              width: w,
                              height: 550,
                              child: ListView(
                                padding: const EdgeInsets.only(top: 55, left: 15,right: 15),
                                children: [
                                  burgerMenu(LocaleKeys.myProfileTitle.tr(context: context),AppAssets.profile,w,const MyProfile(), context),
                                  // burgerMenu(LocaleKeys.wearable.tr(context: context),AppAssets.wearable,w,const SettingsFits(), context),
                                  burgerMenu(LocaleKeys.myClubTitle.tr(context: context),AppAssets.club,w,const MyClubs(), context),
                                  // burgerMenu(LocaleKeys.leaveFeedbackTitle.tr(context: context),AppAssets.leavefeedback,w,const LeaveFeedBack(), context),
                                  // burgerMenu(LocaleKeys.referATeamateTitle.tr(context: context),AppAssets.refer,w,const Teamate(), context),
                                  burgerMenu(LocaleKeys.settingsTitle.tr(context: context),AppAssets.settings,w,const Settings(), context),
                                  // burgerMenu(LocaleKeys.settingsTitle.tr(context: context),AppAssets.settings,w,const FaceDetectorPage(), context),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: h * 0.07,
                                left: w * 0.09,
                                child: GestureDetector(
                                  onTap: () async {
                                    await Provider.of<DeleteLogoutAccount>(context, listen: false).logoutService(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    width: 130,
                                    decoration:  BoxDecoration(
                                        color: AppColors.lightGrey.withOpacity(0.2),
                                        borderRadius: const BorderRadius.all(Radius.circular(30))
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                        LocaleKeys.menuLogoutTitle.tr(context: context),
                                        style:const TextStyle(
                                            color: AppColors.darkMov,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0
                                        )
                                    ),
                                  ),
                                )
                            ),
                          ],
                        )
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}