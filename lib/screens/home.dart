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
import '../functions/calc_date_diff.dart';
import '../functions/task_item.dart';
import '../helpers/category_color.dart';
import '../services/delete_logout_acc.dart';
import '../services/user_tasks.dart';
import '../translations/locale_keys.g.dart';
import 'child_screens/notification.dart';
import 'child_screens/settings.dart';
import 'menu/burger_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
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
    Provider.of<Tasks>(context, listen: false).selfTaskList(context: context);
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
                      GestureDetector(
                            onTap: () async{
                              await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (BuildContext context, setState) => selectTask(w,h,setState)
                                ),
                              ); 
                            },
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: h / 5),
                            child: Container(
                              width: w / 1.2,
                              height: h / 14,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.mov.withOpacity(0.4),
                                    blurRadius: 12.0,
                                    spreadRadius: 5,
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 12.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Start a task',
                                      style: TextStyle(
                                        color: AppColors.darkMov,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(
                                      width: 42,
                                      AppAssets.addTask,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Consumer<Tasks>(
                    builder: (context, data, child) {
                      if(data.tasks.isEmpty){
                        return Column(
                          children: [
                            const SizedBox(height: 75,),
                            SvgPicture.asset(AppAssets.noTask, width: 120,),
                            const Text(
                              'No tasks assigned yet',
                              style: TextStyle(
                                color: AppColors.darkMov,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 15,),
                            const Text(
                              'Once someone assigns you a task, it will show here. In the meantime, you can start a task on your own.',
                              style: TextStyle(
                                color: AppColors.darkMov,
                                fontSize: 14.0
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        );
                      }
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 50.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Assigned tasks',
                                      style: TextStyle(
                                        color: AppColors.darkMov,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Text(
                                          'All',
                                          style: TextStyle(
                                            color: AppColors.darkMov,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        SvgPicture.asset(AppAssets.down, width: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              Padding(
                                padding: EdgeInsets.only(bottom: h / 100),
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  crossAxisSpacing: 15.0,
                                  childAspectRatio: (1 / 1.4),
                                  mainAxisSpacing: 25.0,
                                  children: List.generate(data.tasks.length, (index) {
                                    return GestureDetector(
                                      onTap: (){
                                        startScreeningOrQuestionnaire(
                                          context: context,
                                          title: data.tasks[index]['title'],
                                          assignedTaskId: data.tasks[index]['id'],
                                          name: data.tasks[index]['associated']['name'],
                                          description: data.tasks[index]['associated']['description'],
                                          taskType: data.tasks[index]['task_type'],
                                          estimatedDuration: data.tasks[index]['associated']['estimated_duration'].toString(),
                                          scientificName: data.tasks[index]['associated']['scientific_name'],
                                          slug: data.tasks[index]['associated']['slug'] ?? '',
                                          numberOfItems: data.tasks[index]['task_type'] == 'SCREENING' ?  data.tasks[index]['associated']['number_of_items'] : null
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: h / 4.6,
                                            decoration: BoxDecoration(
                                              color: getTaskBg(data.tasks[index]['task_type']),
                                              borderRadius: BorderRadius.circular(10.0)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 15.0, 
                                                    top: 15.0
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10.0, 
                                                    vertical: 8.0
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(99),
                                                    color: getTaskBgStyle(data.tasks[index]['task_type'])
                                                  ),
                                                  child: Text(
                                                    '${data.tasks[index]['task_type']}',
                                                    style: getTaskTextStyle(data.tasks[index]['task_type'])
                                                  ),
                                                ),
                                                const Spacer(),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: getCategoryAvatar(data.tasks[index]['task_type'])
                                                ),
                                                const Spacer(),
                                              ],
                                            )
                                          ),
                                          const SizedBox(height: 10,),
                                          Text(
                                            data.tasks[index]['title'] ?? '',
                                            style: const TextStyle(
                                              color: AppColors.darkMov,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              if(data.tasks[index]['associated']['estimated_duration'] != null)
                                              Row(
                                                children: [
                                                  SvgPicture.asset(AppAssets.time, width: 12,),
                                                  const SizedBox(width: 5.0,),
                                                  Text(
                                                    '${data.tasks[index]['associated']['estimated_duration']} ${data.tasks[index]['associated']['estimated_duration_unit']}',
                                                    style: const TextStyle(
                                                      fontSize: 11.0,
                                                      color: AppColors.lightMov
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              if(data.tasks[index]['expires_at'] != null)
                                              Text(
                                                'Ends in ${calcDateDiff(data.tasks[index]['expires_at'])}',
                                                style: const TextStyle(
                                                  fontSize: 11.0,
                                                  color: AppColors.orange,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 90,),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ],
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

  Widget selectTask(double w, double h, setState) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Consumer<Tasks>(
        builder: (context, data, child) {
          if(data.selfTasks.isEmpty){
            return Stack(
              children: [
                Container(
                  width: w,
                  height: h/1.05,
                  padding: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 75,),
                        SvgPicture.asset(AppAssets.noTask, width: 120,),
                        const Text(
                          'No tasks assigned yet',
                          style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 15,),
                        const Text(
                          'Once someone assigns you a task, it will show here. In the meantime, you can start a task on your own.',
                          style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 14.0
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
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
                        setState(()=> itemSelected = -1);
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.darkMov,
                      ),
                    ),
                ),)
              ],
            );
          }
          return Stack(
            children: [
              Container(
                width: w,
                height: h/1.05,
                padding: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                      color: AppColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10.0,),
                            const Text(
                              'Start a task',
                              style: TextStyle(
                                color: AppColors.darkMov,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(height: 40.0,),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Select task',
                                style: TextStyle(
                                  color: AppColors.darkMov,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0,),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 15.0,
                              childAspectRatio: (1 / 1.4),
                              mainAxisSpacing: 15.0,
                              children: List.generate(data.selfTasks.length, (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(()=> itemSelected = index);
                                      },
                                      child: Container(
                                        height:  h / 4.6,
                                        decoration: BoxDecoration(
                                          color: getTaskBg(data.selfTasks[index]['task_type'] ?? ''),
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: itemSelected == index
                                          ? Border.all(
                                              color: getBorderColor(data.selfTasks[index]['task_type'] ?? '') 
                                            )
                                          : null
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 15.0, 
                                                top: 15.0
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, 
                                                vertical: 8.0
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(99),
                                                color: getTaskBgStyle(data.selfTasks[index]['task_type'] ?? '')
                                              ),
                                              child: Text(
                                                data.selfTasks[index]['task_type'] ?? '',
                                                style: getTaskTextStyle(data.selfTasks[index]['task_type'] ?? '')
                                              ),
                                            ),
                                            const Spacer(),
                                            Align(
                                              alignment: Alignment.center,
                                              child: getCategoryAvatar(data.selfTasks[index]['task_type'] ?? '')
                                            ),
                                            const Spacer(),
                                          ],
                                        )
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(
                                      data.selfTasks[index]['name'] ?? '',
                                      style: const TextStyle(
                                        color: AppColors.darkMov,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                      if(data.selfTasks[index]['estimated_duration'] != null)
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppAssets.time, width: 12,),
                                            const SizedBox(width: 5.0,),
                                            Text(
                                              '${data.selfTasks[index]['estimated_duration']} ${data.selfTasks[index]['estimated_duration_unit']}',
                                              style: const TextStyle(
                                                fontSize: 11.0,
                                                color: AppColors.lightMov
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                            if(itemSelected != -1)
                            SizedBox(height: h / 4,)
                          ],
                        ),
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
                        setState(()=> itemSelected = -1);
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.darkMov,
                      ),
                    ),
                ),
              ),
              Visibility(
                visible: itemSelected != -1,
                child: Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async{
                     Map result = await context.read<Tasks>().selfTaskSendItem(context: context, taskType: data.selfTasks[itemSelected]['task_type'] , taskId: data.selfTasks[itemSelected]['id'], individualId: '');
                      await startScreeningOrQuestionnaire(
                        context: context,
                        title: '',
                        assignedTaskId: result['id'],
                        name: data.selfTasks[itemSelected]['name'],
                        description: data.selfTasks[itemSelected]['description'],
                        taskType: data.selfTasks[itemSelected]['task_type'],
                        estimatedDuration: data.selfTasks[itemSelected]['estimated_duration'].toString(),
                        scientificName: data.selfTasks[itemSelected]['scientific_name'],
                        slug: data.selfTasks[itemSelected]['slug'] ?? '',
                        numberOfItems: data.selfTasks[itemSelected]['task_type'] == 'SCREENING' ?  data.selfTasks[itemSelected]['number_of_items'] : null
                      );
                    },
                    child: Container(
                      width: w * 0.8,
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
                          'Select task',
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
            ],
          );
        }
      ),
    );
}