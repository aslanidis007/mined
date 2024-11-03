import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mined/constants/assets.dart';
import 'package:mined/functions/notification_status.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/menu/bottom_menu.dart';
import 'package:mined/services/club.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  final PageController _pageController = PageController(initialPage: 0);
  TextEditingController activationController = TextEditingController();
  bool shadowLabel = false;
  List<bool> connect = [false,false,false,false,false,false];
  int _currentPage = 0;
  String error = '';
  String activationValue = '';
  final FocusNode _focusNode = FocusNode();
  bool? isEnable;


  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  isNotificationEnable() async{
    isEnable = await resultNotificationStatus();
    setState(() {});
  }

  changeSliderIndex(int index){
    if (_currentPage < index) {
      _currentPage++;
      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }else{
      PageNavigator(ctx: context).nextPageOnly(page: const BottomMenu());
    }
  }

  @override
  void initState() {
    isNotificationEnable();
    super.initState();
  }

  @override
  void dispose(){
    activationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
         FocusScope.of(context).unfocus();
         shadowLabel = false;
         setState(() {
           
         });
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
             Container(
                decoration: const BoxDecoration(
                  color: AppColors.mov,
                  image: DecorationImage(
                    opacity: 0.25,
                    repeat: ImageRepeat.repeat,
                    image: AssetImage(AppAssets.loginBackgroundImage)
                  )
                ),
               child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  if(isEnable == false)...[
                    notificationTab(w, h),
                  ],                 
                  // syncFits(w, h),
                  activateCode(w, h)
                ],
                ),
             ),
            Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: navigation(w, h),
          ),
          ],
        ),
      ),
    );
  }

  Widget navigation(double w, double h){
    return Container(
      width: w,
      padding: const EdgeInsets.only(bottom: 25.0,left: 25.0,right: 25.0),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                if (_currentPage > 0) {
                  _currentPage--;
                  _pageController.animateToPage(_currentPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                }
              });
            },
            child: const Text(
              'Back',
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.white,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          const SizedBox(width: 85.0,),
          if(isEnable == true)...[
            for (int i = 0; i < 1; i++)
            _buildIndicator(i == _currentPage,w),
          ]else...[
            for (int i = 0; i < 2; i++)
            _buildIndicator(i == _currentPage,w),
          ],
          const SizedBox(width: 85.0,),
          InkWell(
            onTap: (){
              setState(() {
                if(isEnable == true){
                  changeSliderIndex(0);
                }else{
                  changeSliderIndex(1);
                }
              });
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.white,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
        ],
      )
    );
  }
  
  Widget notificationTab(double w, double h){
    return Container(
      width: w,
      padding: const EdgeInsets.only(top: 55.0),
      margin: const EdgeInsets.only(bottom: 70.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80)
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(AppAssets.logoBlack),
              const SizedBox(height: 30.0,),
              Image.asset(AppAssets.notify, height: 110,),
              const SizedBox(height: 20.0,),
              const Text(
                'Enable notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkMov
                ),
              ),
              const SizedBox(height: 10.0,),
              const Text(
                'Notifications allow us to keep you informed \nabout important updates, reminders, and \npersonalised recommendations to support \nyour mental health journey as an athlete. ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mov
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                onTap: () async{
                 final data = await notifyPermission(context);
                 if(data){
                    _currentPage++;
                    _pageController.animateToPage(_currentPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                 }
                },
                child: Container(
                  width: w * 0.8,
                  height: 50.0,
                  margin: const EdgeInsets.only(bottom: 35.0),
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
                      'Enable',
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
          )
        ],
      )
    );
  }
  Widget syncFits(double w, double h){
    return Container(
      width: w,
      padding: const EdgeInsets.only(top: 55.0),
      margin: const EdgeInsets.only(bottom: 70.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80)
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: w,
            height: h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(AppAssets.logoBlack),
                  const SizedBox(height: 30.0,),
                  const Text(
                    'Select a weareble',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkMov
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  const Text(
                    'You can skip this and set it up later in Settings.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkMov
                    ),
                    textAlign: TextAlign.center,
                  ),
                  activateFits(w,h,'Garmin',AppAssets.garmin,0),
                  activateFits(w,h,'Withings',AppAssets.withings,1),
                  activateFits(w,h,'Fitbit',AppAssets.fitbit,2),
                  activateFits(w,h,'Google Fit',AppAssets.googlefit,3),
                  activateFits(w,h,'Oura',AppAssets.oura,4),
                  activateFits(w,h,'Wahoo',AppAssets.wahoo,5),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget activateFits(double w, double h,String title, String icon, int index){
    return Container(
      width: w * 0.8,
      margin: const EdgeInsets.only(top: 30.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
              color: AppColors.darkMov.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 20,
              offset: const Offset(0, 3),
          ),
        ]
      ),
      child: ListTile(
        leading: SvgPicture.asset(icon),
        title: Text(title),
        trailing: connect[index] == false
        ? GestureDetector(
          onTap: (){
            connect[index] = !connect[index];
            setState(() {});
          },
          child: Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGreen, width: 1.5),
              borderRadius: BorderRadius.circular(50)
            ),
            child: const Center(
              child: Text(
                'Connect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
        )
        : GestureDetector(
          onTap: (){
            connect[index] = !connect[index];
            setState(() {});
          },
          child: const SizedBox(
            width: 90,
            child: Center(
              child: Row(
                children: [
                  Text(
                    'Connected',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.lightGreen,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(width: 3,),
                  Icon(Icons.check, size:18, color: AppColors.lightGreen,)
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  Widget activateCode(double w, double h){
    return Container(
      width: w,
      padding: const EdgeInsets.only(top: 55.0),
      margin: const EdgeInsets.only(bottom: 70.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80)
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(AppAssets.logoBlack),
              const SizedBox(height: 30.0,),
              const Text(
                'Enter activation code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkMov
                ),
              ),
              const SizedBox(height: 10.0,),
              const Text(
                'This code should have been provided to you by \nyour club. If you don’t have this now, or want to \nadd more clubs, you can do it in later in \nSettings.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mov
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0,),
              Container(
                width: w * 0.85,
                margin: EdgeInsets.only(top: h * 0.035, bottom: h * 0.025),
                decoration: BoxDecoration(
                boxShadow: shadowLabel == false 
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
                      shadowLabel = true;
                    });
                  },
                  focusNode: _focusNode,
                  onChanged: (value){
                    value.isEmpty ? activationValue = '' : activationValue = value;
                    error = '';
                    setState(() {});
                  },
                  controller: activationController,
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
                    errorText: error != '' ? error : null,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.mov
                      ),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    hintText: 'Club activation code',
                    hintStyle: const TextStyle(
                      color: AppColors.lightMov
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                onTap: ()async{
                  final result = await Provider.of<ClubProvider>(context, listen: false).addClub(clubId: activationController.text);
                  if(result == true){
                    // ignore: use_build_context_synchronously
                    PageNavigator(ctx: context).nextPageOnly(page: const BottomMenu());
                  }else{
                    setState(() {
                      error = 'Invalid code. Please contact your team.';
                    });
                  }
                },
                child: Container(
                  width: w * 0.8,
                  height: 50.0,
                  margin: const EdgeInsets.only(bottom: 35.0),
                  decoration: BoxDecoration(
                    color: activationValue == '' ? AppColors.opacityGreen :AppColors.lightGreen,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    boxShadow: activationValue == ''
                    ? null
                    : [
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
                      'Enter',
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
          )
        ],
      )
    );
  }
  Widget _buildIndicator(bool isActive, double width) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: width * 0.008),
    height: isActive ? 10.0 : 10.0,
    width: isActive ? 40.0 : 10.0,
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10),
      color: isActive
          ? AppColors.lightGreen
          : AppColors.white.withOpacity(0.45),
    ),
  );
}
}