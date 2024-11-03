import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/child_screens/my_clubs.dart';
import 'package:mined/screens/child_screens/my_profile.dart';
import 'package:mined/services/hide_nav_bar.dart';
import 'package:provider/provider.dart';
import '../constants/assets.dart';
import '../constants/color.dart';
import '../functions/calc_date_diff.dart';
import '../functions/task_item.dart';
import '../services/delete_logout_acc.dart';
import '../services/user_tasks.dart';
import '../translations/locale_keys.g.dart';
import 'child_screens/notification.dart';
import 'child_screens/settings.dart';
import 'menu/burger_menu.dart';

class HomePageV1 extends StatefulWidget {
  const HomePageV1({super.key});

  @override
  State<HomePageV1> createState() => _HomePageV1State();
}

class _HomePageV1State extends State<HomePageV1> with SingleTickerProviderStateMixin{
  bool containerSize = false;
  AnimationController? _animationController;
  bool _isVisible = false;
  String lang = 'en';
  final ScrollController _scrollController = ScrollController();

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
        onRefresh: () async{
          await refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              children: [
                Container(
                  width: w,
                  height: h * 0.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
                    color: AppColors.mov,
                    image: DecorationImage(
                      repeat: ImageRepeat.repeat,
                      opacity: .25,
                      image: AssetImage(AppAssets.loginBackgroundImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 55.0, left: 30.0, right: 30.0),
                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:  [
                            InkWell(
                                onTap: () async{
                                  await whenBottomNavBarIsHide(context);
                                },
                                child: SvgPicture.asset(
                                  AppAssets.menu, height: 25,
                                )
                            ),
                            SvgPicture.asset(AppAssets.logoVertical,height: 60,),
                            InkWell(
                                onTap: () async {
                                  PageNavigator(ctx: context).nextPage(page: const NotificationPage());
                                },
                                child: SvgPicture.asset(AppAssets.bell, height: 30,)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<Tasks>(
                    builder: (context, data, child) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: data.tasks.isEmpty
                            ? Container(
                          margin:  EdgeInsets.only(left: w * 0.15),
                          width: 300,
                          height: 175,
                          decoration: const BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: RichText(
                                      text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: LocaleKeys.homeSliderTitle.tr(context: context),
                                                style: const TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 16
                                                )
                                            ),
                                            TextSpan(
                                                text: " ${LocaleKeys.homeSliderTitleBold.tr(context: context)}",
                                                style: const TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                          ]
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(15.0),
                                    width: 240,
                                    child: Wrap(
                                      spacing: 5.0,
                                      runSpacing: 8.0,
                                      children: options.map((String option) {
                                        return GestureDetector(
                                          onTap: () => toggleOption(option),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.0),
                                              border: Border.all(
                                                color: isOptionSelected(option) ? AppColors.darkMov : AppColors.white,
                                                width: isOptionSelected(option) ? 1.0 : 1.0,
                                              ),
                                            ),
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                color: isOptionSelected(option) ? AppColors.darkMov : AppColors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 54,
                                    height: 54,
                                    decoration:  BoxDecoration(
                                        color: AppColors.white.withOpacity(0.2),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20)
                                        ),
                                        image:  const DecorationImage(
                                          image: AssetImage(AppAssets.plus1),

                                        )
                                    ),
                                  )
                              ),
                            ],
                          ),
                        )
                            : CarouselSlider.builder(
                          itemCount: data.tasks.length,
                          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                              InkWell(
                                onTap: () async{
                                  startScreeningOrQuestionnaire(
                                    context: context,
                                    title: data.tasks[itemIndex],
                                    assignedTaskId: data.tasks[itemIndex]['associated']['id'],
                                    name: data.tasks[itemIndex]['associated']['name'],
                                    description: data.tasks[itemIndex]['associated']['description'],
                                    taskType: data.tasks[itemIndex]['task_type'],
                                    estimatedDuration: data.tasks[itemIndex]['associated']['estimated_duration'],
                                    scientificName: data.tasks[itemIndex]['associated']['scientific_name'],
                                    slug: data.tasks[itemIndex]['associated']['slug'],
                                    numberOfItems: data.tasks[itemIndex]['task_type'] == 'SCREENING' ?  data.tasks[itemIndex]['associated']['number_of_items'] : 0
                                  );
                                },
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  color: AppColors.white,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 6.5,horizontal: 12.0),
                                                    decoration: BoxDecoration(
                                                        color:
                                                        data.tasks[itemIndex]['task_type'] == 'SCREENING'
                                                            ? AppColors.mov.withOpacity(0.2) :
                                                        data.tasks[itemIndex]['task_type'] == 'QUESTIONNAIRE'
                                                            ? AppColors.orange.withOpacity(0.2)
                                                            : AppColors.lightGreen.withOpacity(0.2),

                                                        borderRadius: BorderRadius.circular(50)
                                                    ),
                                                    child: Text(
                                                      data.tasks[itemIndex]['task_type'] == 'SCREENING'
                                                          ? 'Screening'
                                                          : data.tasks[itemIndex]['task_type'] == 'QUESTIONNAIRE'
                                                          ? 'Questionnaire'
                                                          : 'Activity',
                                                      style: TextStyle(
                                                          color: data.tasks[itemIndex]['task_type'] == 'SCREENING'
                                                              ? AppColors.mov
                                                              : data.tasks[itemIndex]['task_type'] == 'QUESTIONNAIRE'
                                                              ? AppColors.orange
                                                              : AppColors.lightGreen,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ),
                                                  if(data.tasks[itemIndex]['associated']['estimated_duration'] != null)
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children:  [
                                                      Icon(FontAwesomeIcons.clock,size: 18,color: AppColors.lightMov.withOpacity(0.8),),
                                                      const SizedBox(width: 5.0,),
                                                      Text(
                                                        '${data.tasks[itemIndex]['associated']['estimated_duration']} ${data.tasks[itemIndex]['associated']['estimated_duration_unit']}',
                                                        style: const TextStyle(
                                                            color: AppColors.lightMov,
                                                            fontSize: 11
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 25,),
                                              Text(
                                                '${data.tasks[itemIndex]['title'] ?? ''}',
                                                style: const TextStyle(
                                                    color: AppColors.darkMov,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              Text(
                                                '${data.tasks[itemIndex]['associated']['name']}',
                                                style: const TextStyle(
                                                    color: AppColors.darkMov,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              const SizedBox(height: 50.0,),
                                              if(data.tasks[itemIndex]['expires_at'] != null)
                                              Text(
                                                'Ends in ${calcDateDiff(data.tasks[itemIndex]['expires_at'])}',
                                                style: const TextStyle(
                                                    color: AppColors.orange,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: ClipRRect(
                                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25)),
                                            child: data.tasks[itemIndex]['task_type'] == 'SCREENING'
                                                ? SvgPicture.asset(AppAssets.movrect)
                                                : data.tasks[itemIndex]['task_type'] == 'QUESTIONNAIRE'
                                                ? SvgPicture.asset(AppAssets.orangerec)
                                                : SvgPicture.asset(AppAssets.greenrec)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          options: CarouselOptions(
                            autoPlay: false,
                            viewportFraction: 0.82,
                            enlargeFactor: 0.22,
                            aspectRatio: 2.1,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false
                        ),
                        ),
                      );
                    }
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: GestureDetector(
                //     onTap: (){
                //       containerSize = !containerSize;
                //       setState(() {});
                //     },
                //     child: GestureDetector(
                //       onVerticalDragUpdate: (details) {
                //         setState(() {
                //           _swiperPosition -= details.delta.dy;
                //           if (_swiperPosition <= details.delta.dy) {
                //             _swiperPosition = 0;
                //             if(_swiperPosition <= 0){
                //               _containerHeight = 420.0 ;
                //             }
                //           }
                //           if (_swiperPosition > _maxContainerHeight) {
                //             _swiperPosition = _maxContainerHeight;
                //           }
                //           if(_swiperPosition > 0 && _swiperPosition < 85 ){
                //             _containerHeight = _maxContainerHeight + _swiperPosition;
                //           }
                //           if(_swiperPosition > 84){
                //             _swiperPosition = 84;
                //           }
                //         });
                //       },
                //       child: LayoutBuilder(
                //           builder: (BuildContext ctx, BoxConstraints constraints) {
                //             return AnimatedContainer(
                //                 duration: const Duration(milliseconds: 450),
                //                 width: w,
                //                 height: constraints.maxHeight >= 860 ? _containerHeight + 55 : constraints.maxHeight <= 710 ? _containerHeight - 90 : _containerHeight + 30,
                //                 decoration:  BoxDecoration(
                //                     color: AppColors.white,
                //                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                //                     boxShadow: [
                //                       BoxShadow(
                //                           color: AppColors.lightGrey.withOpacity(0.3),
                //                           spreadRadius: 2,
                //                           blurRadius: 25,
                //                           offset: const Offset(0, 3)
                //                       )
                //                     ]
                //                 ),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   mainAxisSize: MainAxisSize.max,
                //                   children: [
                //                     Center(
                //                       child: Container(
                //                         margin: const EdgeInsets.only(top: 20.0),
                //                         width: 65,
                //                         height: 8,
                //                         decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(20),
                //                             color: AppColors.lightGrey.withOpacity(0.1)
                //                         ),
                //                       ),
                //                     ),
                //                     const SizedBox(height: 40.0,),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 35.0),
                //                       child: Text(
                //                         LocaleKeys.homeIndexes.tr(context: context),
                //                         style: const TextStyle(
                //                             color: AppColors.lightMov,
                //                             fontSize: 16.0
                //                         ),
                //                       ),
                //                     ),
                //                     Expanded(
                //                       child: Consumer<IndexesAndTasks>(
                //                           builder: (context, data, child) {
                //                             scrollToTop();
                //                             return ListView.builder(
                //                                 padding: const EdgeInsets.only(top: 12.0),
                //                                 controller: _scrollController,
                //                                 physics: const ScrollPhysics(),
                //                                 itemCount: data.indexData.length,
                //                                 itemBuilder: (context, index){
                //                                   final key = data.indexData.keys.elementAt(index);
                //                                   return Padding(
                //                                     padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                //                                     child: Container(
                //                                       decoration:  BoxDecoration(
                //                                           boxShadow: [
                //                                             BoxShadow(
                //                                                 color: AppColors.mov.withOpacity(0.15),
                //                                                 blurRadius: 20.0,
                //                                                 offset: const Offset(0,5),
                //                                                 spreadRadius:4.0
                //                                             )
                //                                           ]
                //                                       ),
                //                                       child: InkWell(
                //                                         onTap: (){
                //                                           PageNavigator(ctx: context).nextPage(page: FeedbackScreen(title: key,index: index+1,));
                //                                         },
                //                                         child: Card(
                //                                           color: AppColors.white,
                //                                           shape: RoundedRectangleBorder(
                //                                               borderRadius: BorderRadius.circular(15)
                //                                           ),
                //                                           child: Padding(
                //                                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                //                                             child: Row(
                //                                               mainAxisAlignment: MainAxisAlignment.start,
                //                                               crossAxisAlignment: CrossAxisAlignment.center,
                //                                               children:  [
                //                                                 SvgPicture.asset(AppAssets.cardicon,),
                //                                                 const SizedBox(width: 20.0,),
                //                                                 Text(
                //                                                   '$key',
                //                                                   style: const TextStyle(
                //                                                       color: AppColors.darkMov,
                //                                                       fontWeight: FontWeight.w700,
                //                                                       fontSize: 16
                //                                                   ),
                //                                                 ),
                //                                                 const Spacer(),
                //                                                 Row(
                //                                                   children: [
                //                                                     Text(
                //                                                       LocaleKeys.homeViewTitle.tr(context: context),
                //                                                       style: const TextStyle(
                //                                                           color: AppColors.lightMov,
                //                                                           fontWeight: FontWeight.w400,
                //                                                           fontSize: 14
                //                                                       ),
                //                                                     ),
                //                                                     const SizedBox(width: 15,),
                //                                                     const Icon(
                //                                                       FontAwesomeIcons.arrowRight,
                //                                                       size: 15,
                //                                                       color: AppColors.lightGreen,
                //                                                     )
                //                                                   ],
                //                                                 ),
                //                                               ],
                //                                             ),
                //                                           ),
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   );
                //                                 }
                //                             );
                //                           }
                //                       ),
                //                     ),
                //                   ],
                //                 )
                //             );
                //           }
                //       ),
                //     ),
                //   ),
                // ),
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
        ),
      ),
    );
  }
}