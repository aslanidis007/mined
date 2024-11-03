import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/services/leave_feedback.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../helpers/list_by_date.dart';


class LeaveFeedBack extends StatefulWidget {
  const LeaveFeedBack({super.key});

  @override
  State<LeaveFeedBack> createState() => _LeaveFeedBackState();
}

class _LeaveFeedBackState extends State<LeaveFeedBack> {
  bool visible = false, visibleTextArea = false;
  List selected = [];
  String selectEvent = '';
  TextEditingController textController = TextEditingController();
  String eventValue = '', textAreaValue = '';
  DateTime selectedDate = DateTime.now();
  List today = [];
  List yesterday = [];
  List older = [];
  bool checkedValue = false;
  List isExpandedToday = [];
  List isExpandedYesterday = [];
  List isExpandedOlder = [];
  final FocusNode _focusNode = FocusNode();


  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }
  loadProvider(context) async{
    await Provider.of<LeaveFeedBackService>(context, listen: false).showFeedback(context: context);
    await Provider.of<LeaveFeedBackService>(context, listen: false).showFeedbackRecipient(context: context);
  }
  clearFields(context) async{
    await Provider.of<LeaveFeedBackService>(context, listen: false).showFeedback(context: context);
    setState(() {
      selected = [];
      eventValue  = '';
      _focusNode.unfocus();
    });   
    textController.clear();     
    Navigator.pop(context);  
  }
  @override
  void initState() {
    loadProvider(context);
    super.initState();
  }

  sendFeedBack({
    required context,
    required double w,
    required double h, 
    required String text, 
    required bool isAnonymous,
    required String receivingTeamId,
    required String receivingTeamName
    }) async{
    bool statusCode = await Provider.of<LeaveFeedBackService>(context, listen: false).addFeedback(
      context: context,
      feedback: text, 
      receivingTeamId: receivingTeamId,
      receivingTeamName: receivingTeamName,
      isAnonymous: isAnonymous
    );
    if(statusCode == true){
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: false,
        barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
        context: context,
        builder: (context) => feedbackSubmitted(w,h),
      );
    } 
  }
  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
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
                                    LocaleKeys.LeaveFeedBackTitle.tr(context: context),
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
                                Tab(text: LocaleKeys.addFeedBackTitle.tr(context: context),),
                                Tab(text: LocaleKeys.pastFeedBackTitle.tr(context: context))
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
                    SizedBox(
                      width: w,
                      height: h * 0.75,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer<LeaveFeedBackService>(
                              builder: (context, data, child) { 
                                for(var x = 0; x < data.feedbackRecipient.length; x++){
                                  selected.add(false);
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      LocaleKeys.addFeedBackChoosTitle.tr(context: context),
                                        style: const TextStyle(
                                          color: AppColors.darkMov,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        visible = !visible;
                                      });
                                    },
                                    child: Container(
                                      width: w * 0.85,
                                      height: 50,
                                      margin: EdgeInsets.only(bottom: visible == true ? h * 0.010 : h * 0.025,),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(color: AppColors.lightMov),
                                        boxShadow: visible == false 
                                          ? null 
                                          :[
                                            BoxShadow(
                                              color: AppColors.darkMov.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                          ),
                                        ],                    
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  eventValue != '' ? eventValue : 'Choose team/person',
                                                  style: TextStyle(
                                                    color: eventValue != '' ?AppColors.darkMov :AppColors.lightMov,
                                                    fontSize: 16
                                                  ),
                                                ),
                                                Icon(
                                                  visible == true ? FontAwesomeIcons.chevronUp :FontAwesomeIcons.chevronDown,
                                                  size: 15,
                                                  color: AppColors.lightMov,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: data.feedbackRecipient.isEmpty ? false : visible,
                                    child: Container(
                                      width: w * 0.85,
                                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                                      margin: EdgeInsets.only(bottom: h * 0.025,),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.lightMov),
                                        boxShadow: visible == false 
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
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for(var x = 0; x < data.feedbackRecipient.length; x++)
                                            eventSelected('${data.feedbackRecipient['$x']['name']} / ${data.feedbackRecipient['$x']['club'][0]['name']}', selected, x,data.feedbackRecipient['$x']['id']),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ],
                                );
                              }
                            ),
                              Visibility(
                                visible: visibleTextArea,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0, left: 45),
                                      child: Text(
                                        LocaleKeys.addEventTellUsMoreTitle.tr(context: context),
                                          style: const TextStyle(
                                            color: AppColors.darkMov,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),
                                    ),
                                    Container(
                                      width: w * 0.8,
                                      height: 80,
                                      padding: const EdgeInsets.only(left: 15),
                                      margin: const EdgeInsets.only(left: 45,),
                                      decoration:  BoxDecoration(
                                        border: Border.all(color: AppColors.darkMov,width: 1.2),
                                        borderRadius: const BorderRadius.all(Radius.circular(25))
                                      ),
                                      child: TextFormField(
                                        focusNode: _focusNode,
                                        minLines: 6, // any number you need (It works as the rows for the textarea)
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: LocaleKeys.addFeedbackSummariseTitle.tr(context: context),
                                          hintStyle: const TextStyle(color: AppColors.lightMov)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0, top: 20),
                                    child: Text(
                                      LocaleKeys.addFeedbackFreeTextTitle.tr(context: context),
                                        style: const TextStyle(
                                          color: AppColors.darkMov,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                  ),
                                  Container(
                                    width: w * 0.85,
                                    height: 180,
                                    padding: const EdgeInsets.only(left: 15, ),
                                    decoration:  BoxDecoration(
                                      border: Border.all(color: AppColors.darkMov,width: 1.2),
                                      borderRadius: const BorderRadius.all(Radius.circular(25))
                                    ),
                                    child: TextFormField(
                                      onChanged: (value){
                                        if(value.isNotEmpty){
                                          setState(() {
                                            textAreaValue = value;
                                          });
                                        }else{
                                          setState(() {
                                            textAreaValue = '';
                                          });
                                        }
                                      },
                                      focusNode: _focusNode,
                                      controller: textController,
                                      minLines: 6, // any number you need (It works as the rows for the textarea)
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: LocaleKeys.addFeedbackFreeTextHint.tr(context: context),
                                        hintStyle: const TextStyle(color: AppColors.lightMov)
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: w * 0.85,
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      checkColor: AppColors.lightMov,
                                      activeColor: Colors.transparent,
                                      checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                        side: const BorderSide(color: Colors.white),
                                      ),
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                          width: 1.4, 
                                          color: !checkedValue 
                                          ? AppColors.lightMov 
                                          : AppColors.darkMov
                                        ),
                                      ),
                                      title:Transform.translate(
                                        offset: const Offset(-15,0),
                                        child: RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                              text: LocaleKeys.anonymousTitle.tr(context: context),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.lightMov,
                                              ),
                                          ),
                                        ),
                                      ),
                                      value: checkedValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          checkedValue = newValue!;
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                    ),
                                  ),
                                ],
                              ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () async{
                                  if(textAreaValue.isNotEmpty &&
                                    eventValue.isNotEmpty){
                                      await sendFeedBack(
                                        context: context,
                                        w: w,
                                        h: h,
                                        isAnonymous: checkedValue,
                                        text: textAreaValue,
                                        receivingTeamId: selectEvent,
                                        receivingTeamName: eventValue
                                      );
                                    }
                                },
                                child: Container(
                                  width: w * 0.8,
                                  height: 65.0,
                                  margin:  EdgeInsets.only(top: h * 0.11,bottom: h * 0.15),
                                  decoration: BoxDecoration(
                                    color: textAreaValue.isEmpty ||
                                    eventValue.isEmpty
                                    ? AppColors.opacityGreen
                                    : AppColors.lightGreen,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    boxShadow: textAreaValue.isEmpty ||
                                    eventValue.isEmpty
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
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.addFeedbackButton.tr(context: context),
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
                          ],
                        ),
                      ),
                    ),
                    Consumer<LeaveFeedBackService>(
                      builder: (context, data, child) {
                        List<Map<String, dynamic>> todayList = [];
                        List<Map<String, dynamic>> yesterdayList = [];
                        List<Map<String, dynamic>> olderList = [];
                        var dateTime = DateTime.now();
                        DateTime dateWithoutTime = DateTime(dateTime.year,dateTime.month,dateTime.day);  
                        
                        for (var element in data.feedBack) {
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
                          for(var x = 0; x < olderList.length; x++){
                            isExpandedOlder.add(false);
                          }
                          for(var x = 0; x < yesterdayList.length; x++){
                            isExpandedYesterday.add(false);
                          }
                        if(data.feedBack.isEmpty){
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
                          feedbackTitleToday: (title) => feedbackTitle('Today'),
                          feedbackListYesterday: (feedBack, index, expanded) => feedbackList(yesterdayList, index, isExpandedYesterday),
                          feedbackTitleYesterday: (title) => feedbackTitle('Yesterday'),
                          feedbackListOlder: (feedBack, index, expanded) => feedbackList(olderList, index, isExpandedOlder),
                          feedbackTitleOlder: (title) => feedbackTitle('Older'),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          )
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
              '${LocaleKeys.forTitle.tr(context: context)}: ${feedBack[index]['recipient']['name']}',
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
          feedBack[index]['feedback'].length < 135
          ? Text(
            '${feedBack[index]['feedback']}',
            style: const TextStyle(
              color: AppColors.lightMov,
              fontSize: 14
            ),
          )
          : Text(
            !expanded[index]
            ? '${feedBack[index]['feedback']}'.substring(0, 135)
            : '${feedBack[index]['feedback']}',
            style: const TextStyle(
              color: AppColors.lightMov,
              fontSize: 14
            ),
          ),
          feedBack[index]['feedback'].length < 130
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
                            LocaleKeys.successFeedBackMessageTitle.tr(context: context),
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
                              clearFields(context);
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
                                  LocaleKeys.addNew.tr(context: context),
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
                    clearFields(context);
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
      onTap: () async{     
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
                visible = false;
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
}