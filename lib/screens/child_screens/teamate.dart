
import 'package:azlistview/azlistview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/routes/routes.dart';
import 'package:mined/screens/child_screens/teamate_person.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../helpers/list_by_date.dart';
import '../../services/team_mate.dart';

class _AZItem extends ISuspensionBean{
  final String title;
  final String tag;
  final String sub;
  final String user;

  _AZItem(
    {
      required this.sub,
      required this.title,
      required this.tag,
      required this.user,
    }
  );

  @override
  String getSuspensionTag() => tag;
}

class Teamate extends StatefulWidget {
  const Teamate({super.key,});

  @override
  State<Teamate> createState() => _TeamateState();
}

class _TeamateState extends State<Teamate> {
  List<_AZItem> items = [];
  List teamMateList = [];
  bool visible = false, visibleTextArea = false;
  List selected = [false,false,false,false,false,false,false];
  String selectEvent = '';
  TextEditingController searchController = TextEditingController();
  String eventValue = '', textAreaValue = '';
  DateTime selectedDate = DateTime.now();
  List today = [];
  List yesterday = [];
  List older = [];
  bool checkedValue = false;
  List isExpandedToday = [];
  List isExpandedYesterday = [];
  List isExpandedOlder = [];
  String  searchValue = '';
  

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }


  loadProvider(context) async{
    await Provider.of<TeamMateProvider>(context, listen: false).teamMateList(context: context);
    await Provider.of<TeamMateProvider>(context, listen: false).teamMateReferral(context: context);
    for(var x =0; x < Provider.of<TeamMateProvider>(context, listen: false).teamMateData.length; x++){
      teamMateList.add(Provider.of<TeamMateProvider>(context, listen: false).teamMateData[x]);
    }
    setState(() {});
  }

  @override
  void initState() {
    initList(context);
    super.initState();
  }

  void initList(context) async {
    await loadProvider(context);
    items = teamMateList.map((item)=> _AZItem(title: item['name'], tag: item['name'][0].toUpperCase(), sub: item['club'], user: item['user_id'])).toList();
    items.sort((a,b) => a.title.compareTo(b.title));
    setState(() {});
  }


  String truncateTitle(String title,int maxTitle) {
    // Replace this with your logic to truncate the title
    if (title.length > maxTitle) {
      return '${title.substring(0, maxTitle)}...';
    }
    return title;
  }

  String getInitial(String name) {
  return name.isNotEmpty ? name[0] : '';
}

List<String> splitName(String fullName) {
  return fullName.trim().split(' ');
}

String extractInitials(String fullName) {
  final nameParts = splitName(fullName);
  if (nameParts.length >= 2) {
    final firstNameInitial = getInitial(nameParts[0]);
    final lastNameInitial = getInitial(nameParts[1]);
    return '$firstNameInitial$lastNameInitial';
  } else {
    return 'AA';
  }
}


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: w,
              height: h * 0.25,
              child: Stack(
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
                                  LocaleKeys.referATeamateTitle.tr(context: context),
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
                  Positioned(
                    top: 120,
                    left: 35,
                    right: 35,
                    child: Container(
                      width: w,
                      decoration: const BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            indicatorPadding: const EdgeInsets.all(6),
                            unselectedLabelColor: AppColors.lightGrey.withOpacity(0.3),
                            labelColor: AppColors.darkMov,
                            indicator: const BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ),
                            tabs: [
                              Tab(text: LocaleKeys.refereTeamateTitle.tr(context: context),),
                              Tab(text: LocaleKeys.pastReferrals.tr(context: context),)
                            ],
                          )
                        ]
                      ),
                    ),
                  ),   
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const ScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Container(
                        width: w * 0.85,
                        margin: EdgeInsets.only(top: h * 0.002, bottom: h * 0.03),
                        child: TextFormField(
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                searchValue = '';
                              });
                            }else{
                              setState(() {
                                searchValue = value;
                              });
                            }
                          },
                          controller: searchController,
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
                            // ignore: deprecated_member_use
                            suffixIcon: const Icon(FontAwesomeIcons.search,size: 20,),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.darkMov
                              ),
                              borderRadius: BorderRadius.circular(40)
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            hintText: LocaleKeys.searchTeamate.tr(context: context),
                            hintStyle: const TextStyle(
                              color: AppColors.lightMov
                            ),
                            
                          ),
                        ),
                      ),
                      Expanded(
                        child: Consumer<TeamMateProvider>(
                          builder: (context, dataList, child) {
                            final searchList = dataList.teamMateData.where((element) => 
                             element['name'].toLowerCase().toString().trim().contains(searchValue.toString().toLowerCase().trim())
                             || element['club'].toLowerCase().toString().trim().contains(searchValue.toString().toLowerCase().trim())
                            ).toList();
                            if(searchValue.isNotEmpty){
                              return ListView.builder(
                                itemCount: searchList.length,
                                itemBuilder: (context, index){
                                  return ListTile(
                                    leading: Container(
                                      height:40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: AppColors.darkMov,
                                          borderRadius: BorderRadius.circular(100)
                                        //more than 50% of width makes circle
                                      ),
                                      child: Center(
                                        child: Text(
                                            '${searchList[index]['name']}',
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text('${searchList[index]['club']}'),
                                    title: Text('${searchList[index]['name']}',style: const TextStyle(color: AppColors.darkMov),),
                                    // Other item properties...
                                  );
                                },
                              );
                            }
                            return AzListView(
                              data: items,
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = items[index];
                                final nameSurname = items[index].title;
                                return InkWell(
                                  onTap: (){
                                    PageNavigator(ctx: context).nextPage(page: TeamatePerson(fullName: items[index].title, userId: items[index].user,));
                                  },
                                  child: ListTile(
                                    leading: Container(
                                      height:40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: AppColors.darkMov,
                                          borderRadius: BorderRadius.circular(100)
                                        //more than 50% of width makes circle
                                      ),
                                      child: Center(
                                        child: Text(
                                          extractInitials(nameSurname),
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(item.sub),
                                    title: Text(item.title,style: const TextStyle(color: AppColors.darkMov),),
                                    // Other item properties...
                                  ),
                                );
                              },
                              physics: const BouncingScrollPhysics(), // Optional: Add physics if needed
                              susItemBuilder: (BuildContext context, int index) {
                                // Index bar items (A, B, C, ...)
                                return SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: Center(
                                    child: Text(
                                      items[index].title[0], // Assuming the name starts with alphabet
                                      style: const TextStyle(fontSize: 14.0, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                              indexBarOptions: const IndexBarOptions(
                                needRebuild: true,
                                indexHintAlignment: Alignment.center
                              ),
                              // Customize the index bar data as per your item list
                            );
                          }
                        ),
                      ),    
                    ],
                  ),   
                  Consumer<TeamMateProvider>(
                    builder: (context, data, child) {
                        List<Map<String, dynamic>> todayList = [];
                        List<Map<String, dynamic>> yesterdayList = [];
                        List<Map<String, dynamic>> olderList = [];
                        var dateTime = DateTime.now();
                        DateTime dateWithoutTime = DateTime(dateTime.year,dateTime.month,dateTime.day);  
                        
                        for (var element in data.referral) {
                          DateTime createdAt = DateTime.parse(element['created_at']);
                          createdAt = DateTime(createdAt.year, createdAt.month, createdAt.day);
                          Duration difference = dateWithoutTime.difference(createdAt);
                          
                          if (difference.inDays == 0) {
                            // The feedback is from today
                            todayList.add(element);
                          } else if (difference.inDays == 1) {
                            // The feedback is from yesterday
                            yesterdayList.add(element);
                          } else {
                            // The feedback is older than yesterday
                            olderList.add(element);
                          }
                        }
                          for(var x = 0; x < todayList.length; x++){
                            isExpandedToday.add(false);
                          }
                          for(var x = 0; x < older.length; x++){
                            isExpandedOlder.add(false);
                          }
                          for(var x = 0; x < yesterdayList.length; x++){
                            isExpandedYesterday.add(false);
                          }
                        if(data.referral.isEmpty){
                          return const SizedBox();
                        }
                        return listByDate(
                          w: w,
                          h: h,
                          todayList: todayList,
                          yesterdayList: yesterdayList,
                          olderList: olderList,
                          isExpandedToday: isExpandedToday,
                          isExpandedYesterday: isExpandedToday,
                          isExpandedOlder: isExpandedOlder,
                          feedbackListToday: (feedBack, index, expanded) => feedbackList(todayList, index, isExpandedToday),
                          feedbackTitleToday: (title) => feedbackTitle(LocaleKeys.eventHistoryTodayTitle.tr(context: context)),
                          feedbackListYesterday: (feedBack, index, expanded) => feedbackList(yesterdayList, index, isExpandedYesterday),
                          feedbackTitleYesterday: (title) => feedbackTitle(LocaleKeys.eventHistoryYesterdayTitle.tr(context: context)),
                          feedbackListOlder: (feedBack, index, expanded) => feedbackList(olderList, index, isExpandedOlder),
                          feedbackTitleOlder: (title) => feedbackTitle(LocaleKeys.eventHistoryOlderTitle.tr(context: context)),
                        );
                      }
                    ),
                ],
              )
            ),
          ],
        )
      ),
    );
  }
  Widget feedbackSubmitted(double w, var h) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.5,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SvgPicture.asset(AppAssets.feedback),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                            LocaleKeys.feedbackSuccessMessageTitle.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              eventValue  = '';
                              searchController.clear();
                              
                            },
                            child: Container(
                              width: w * 0.8,
                              height: 65.0,
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
                                  LocaleKeys.AddNew.tr(context: context),
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
  Widget eventSelected(String name, List selected, int index , String eventId){
    return GestureDetector(
      onTap: (){     
        for (int i = 0; i < selected.length; i++){
          if(i == index){
            setState(() {
              selected[i] = !selected[i];
              selectEvent = eventId;
              if(selected[i] == false){
                eventValue = '';
              }else{
                eventValue = name;
                if(eventValue == 'Other'){
                  setState(() {
                    visibleTextArea = true;
                  });
                }
              }
            });
          }else{
            selected[i] = false;
            visibleTextArea = false;
            setState(() {});
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: selected[index]== false 
                ? AppColors.lightMov
                : AppColors.darkMov,
                fontSize: 16
              ),
            ),
            Icon(
              selected[index]== false  
              ? null
              : FontAwesomeIcons.check,
              size: 15,
              color: AppColors.lightMov,
            ),
          ],
        ),
      ),
    );
  }

    Widget feedbackTitle(String title){
      return Text(
        title,
          style: const TextStyle(
            color: AppColors.darkGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
      );
    }

    Widget feedbackList(List feedBack, int index, List expanded){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              '${LocaleKeys.forTitle.tr(context: context)}: ${feedBack[index]['referee']['name']}',
              style: const TextStyle(
                color: AppColors.darkMov,
                fontSize: 18,
                fontWeight: FontWeight.w700
              ),
            ),
            subtitle: Text(
              '${DateTime.parse(feedBack[index]['created_at']).day} ${DateFormat('MMM').format(DateTime.parse(feedBack[index]['created_at']))}',
              style: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400
                ),
            ),
            trailing: feedBack[index]['anonymous'] == 1
            ? SvgPicture.asset(AppAssets.anonymous)
            : const SizedBox()
          ),
          feedBack[index]['referral_reason'].length < 135
          ? Text(
            '${feedBack[index]['referral_reason']}',
            style: const TextStyle(
              color: AppColors.lightMov,
              fontSize: 14
            ),
          )
          : Text(
            !expanded[index]
            ? '${feedBack[index]['referral_reason']}'.substring(0, 135)
            : '${feedBack[index]['referral_reason']}',
            style: const TextStyle(
              color: AppColors.lightMov,
              fontSize: 14
            ),
          ),
          feedBack[index]['referral_reason'].length < 130
          ? const SizedBox()
          : InkWell(
            onTap: (){
              setState(() {
                  expanded[index] = !expanded[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Text(
                    !expanded[index] ? LocaleKeys.readmore.tr(context: context) : LocaleKeys.readless.tr(context: context),
                    style: const TextStyle(
                      color: AppColors.darkMov,
                      fontSize: 12
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Icon(
                    !expanded[index] ? FontAwesomeIcons.angleDown : FontAwesomeIcons.angleUp,
                    color: AppColors.darkMov,
                    size: 14,
                  )
                ],
              ),
            ),
          )
        ],
      );
    }
}