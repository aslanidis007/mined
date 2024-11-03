
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mined/services/dropdown_selection.dart';
import 'package:mined/services/life_event.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../constants/assets.dart';
import '../constants/color.dart';
import '../helpers/dropdown.dart';
import '../helpers/textLength.dart';


class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  TextEditingController endDateController= TextEditingController();
  String otherValue = '';
  String titleValue = '';
  String startDateValue = '',endDateValue = '';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  List selected = [];

  resetAll(context) async{
    await Provider.of<LifeEvent>(context, listen: false).showLifeEvent(context: context);
    await Provider.of<LifeEvent>(context, listen: false).showLifeEventType(context: context);
    await Provider.of<DropDownSelection>(context, listen: false).clearSelection();
    setState(() {
      startDateController.clear();
      textEditingController.clear();
      labelController.clear();
      endDateController.clear();
      otherValue = '';
      titleValue = '';
      startDateValue = '';
      endDateValue = '';
      selected = [];
      selectedStartDate = DateTime.now();
      selectedEndDate = DateTime.now();
    });
    Navigator.pop(context);
  }

  @override
  void dispose(){
    startDateController.dispose();
    textEditingController.dispose();
    endDateController.dispose();
    labelController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    Provider.of<LifeEvent>(context,listen: false).showLifeEvent(context: context);
    Provider.of<LifeEvent>(context,listen: false).showLifeEventType(context: context);
    Provider.of<DropDownSelection>(context,listen: false);
    super.initState();
  }



  addEvent(context,double w, double h, String startDate, String endDate, String title, int? eventTypeId) async{
     String statusCode = await Provider.of<LifeEvent>(context,listen: false).addLifeEvent(
      context: context,
      type: eventTypeId,
      startDate: startDate,
      endDate: endDate,
      title: title,
      note: Provider.of<DropDownSelection>(context, listen: false).selectedItemValue == 'Other' ?  otherValue : Provider.of<DropDownSelection>(context, listen: false).selectedItemValue
    );
    if(statusCode == '200' || statusCode == '201'){
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: false,
        barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
        context: context,
        builder: (context) => successMessage(w,h),
      ); 
    }
  }

  deleteEvent(context, String lifeEventId) async{
     String statusCode = await Provider.of<LifeEvent>(context,listen: false).deleteLifeEvent(
      lifeEventId: lifeEventId
    );

    if(statusCode == '200' || statusCode == '201'){
      await Provider.of<LifeEvent>(context,listen: false).showLifeEvent(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Consumer<DropDownSelection>(
      builder: (context, item, child) {
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
                        child:  Padding(
                          padding: const EdgeInsets.only(top: 65.0, left: 30.0, right: 30.0),
                          child: Column(
                            children: [
                              Text(
                                context.tr(LocaleKeys.addLifeEventTitle),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
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
                                  Tab(text: LocaleKeys.addEventTitle.tr(context: context)),
                                  Tab(text: LocaleKeys.eventHistoryTitle.tr(context: context),)
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
                      Consumer<LifeEvent>(
                        builder: (context, data, child) {
                          final otherType = data.lifeEventType.where((element) => element['id'] == 0);
                          if(otherType.isEmpty){
                            data.lifeEventType.add({'id':0,'name':'OTHER','decription':'Custom event type','owner_id':null});
                            for(var x = 0; x < data.lifeEventType.length; x++){
                                selected.add(false);
                            }
                          }
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: w * 0.8,
                                    height: h,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0),
                                      child: Text(
                                        LocaleKeys.addEventChooseEventTitle.tr(context: context),
                                          style: const TextStyle(
                                            color: AppColors.darkMov,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),
                                    ),
                                    dropdownButton(
                                      context: context,
                                      w: w,
                                      h: h,
                                      data: data.lifeEventType,
                                      typeDropdown: 'event',
                                      selected: selected,
                                      genderValue: ''
                                    ),
                                    Visibility(
                                      visible: item.visibleTextArea,
                                      child: SizedBox(
                                          width: w * 0.8,
                                          height: 80,
                                          child: TextFormField(
                                            onChanged: (value){
                                              if(value.isNotEmpty){
                                                titleValue = value;
                                              }else{
                                                titleValue ='';
                                              }
                                              setState(() {});
                                            },
                                            controller: labelController,
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
                                              hintText: LocaleKeys.addEventOtherHintTitle.tr(context: context),
                                              hintStyle: const TextStyle(
                                                color: AppColors.lightMov
                                              ),
                                            ),
                                          ),
                                        ),
                                    ),
                                    Visibility(
                                      visible: item.visibleTextArea,
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0,),
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
                                            decoration:  BoxDecoration(
                                              border: Border.all(color: AppColors.darkMov,width: 1.2),
                                              borderRadius: const BorderRadius.all(Radius.circular(25))
                                            ),
                                            child: TextFormField(
                                              onChanged: (value){
                                                if(value.isEmpty){
                                                  otherValue = '';
                                                  setState(() {});
                                                }else{
                                                  otherValue = value;
                                                  setState(() {});
                                                }
                                              },
                                              controller: textEditingController,
                                              minLines: 6, // any number you need (It works as the rows for the textarea)
                                              keyboardType: TextInputType.multiline,
                                              maxLines: null,
                                              decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                hintText: LocaleKeys.addEventTellUsHintDescription.tr(context: context),
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
                                            LocaleKeys.addEventDateTitle.tr(context: context),
                                              style: const TextStyle(
                                                color: AppColors.darkMov,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                        ),
                                        Container(
                                          width: w * 0.45,
                                          margin: EdgeInsets.only(bottom: h * 0.025,),                         
                                          child: TextFormField(
                                            onTap: () async{
                                              final DateTime? dateTime = await showDatePicker(
                                                builder: (BuildContext context, Widget? child){
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(
                                                      colorScheme: const ColorScheme.light(
                                                        primary: AppColors.mov, 
                                                        onPrimary: AppColors.white, 
                                                        secondary: AppColors.darkMov, 
                                                        onSecondary: AppColors.darkMov, 
                                                        error: AppColors.darkMov, 
                                                        onError: AppColors.darkMov, 
                                                        background: AppColors.darkMov, 
                                                        onBackground: AppColors.darkMov, 
                                                        surface: AppColors.darkMov, 
                                                        onSurface: AppColors.darkMov
                                                      )
                                                    ),
                                                    child: child!,
                                                    
                                                  );
                                                },
                                                context: context,
                                                initialDate: selectedStartDate,
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2030)
                                              );
                                              if(dateTime != null){
                                                setState(() {
                                                  selectedStartDate = dateTime;
                                                  startDateValue = dateTime.toString();
                                                });
                                              }
                                            },
                                            readOnly: true,
                                            controller: startDateController,
                                            style: const TextStyle(
                                              color: AppColors.lightMov
                                            ),
                                            cursorColor: AppColors.lightMov,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: AppColors.white,
                                              suffixIcon: const Icon(
                                                Icons.calendar_month, 
                                                size: 20,
                                                color: AppColors.lightMov,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: AppColors.lightMov
                                                ),
                                                borderRadius: BorderRadius.circular(40)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: AppColors.lightMov
                                                ),
                                                borderRadius: BorderRadius.circular(40)
                                              ),
                                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              hintText: startDateValue != '' 
                                              ?'${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}' 
                                              :LocaleKeys.addEventDateSelectionTitle.tr(context: context),
                                              hintStyle: TextStyle(
                                                color: startDateValue != '' 
                                                ?AppColors.darkMov 
                                                :AppColors.lightMov
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: item.isHaveEndDate,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Padding(
                                            padding: const EdgeInsets.only(bottom: 15.0, top: 20),
                                            child: Text(
                                              LocaleKeys.addEventDateTitle.tr(context: context),
                                                style: const TextStyle(
                                                  color: AppColors.darkMov,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w700
                                                ),
                                              ),
                                          ),
                                          Container(
                                            width: w * 0.45,
                                            margin: EdgeInsets.only(bottom: h * 0.025,),                         
                                            child: TextFormField(
                                              onTap: () async{
                                                final DateTime? dateTime = await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedEndDate,
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime(2030)
                                                );
                                                if(dateTime != null){
                                                  setState(() {
                                                    selectedEndDate = dateTime;
                                                    endDateValue = dateTime.toString();
                                                  });
                                                }
                                              },
                                              readOnly: true,
                                              controller: endDateController,
                                              style: const TextStyle(
                                                color: AppColors.lightMov
                                              ),
                                              cursorColor: AppColors.lightMov,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: AppColors.white,
                                                suffixIcon: const Icon(
                                                  Icons.calendar_month, 
                                                  size: 20,
                                                  color: AppColors.lightMov,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: AppColors.lightMov
                                                  ),
                                                  borderRadius: BorderRadius.circular(40)
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: AppColors.lightMov
                                                  ),
                                                  borderRadius: BorderRadius.circular(40)
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                                hintText: endDateValue != '' 
                                                ?'${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}' 
                                                :LocaleKeys.addEventDateSelectionTitle.tr(context: context),
                                                hintStyle: TextStyle(
                                                  color: endDateValue != '' 
                                                  ?AppColors.darkMov 
                                                  :AppColors.lightMov
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                      onTap: () async{
                                          addEvent(context,w,h,selectedStartDate.toString(),selectedEndDate.toString(), titleValue, item.typeId);
                                      },
                                      child: Container(
                                        width: w * 0.8,
                                        height: 50.0,
                                        margin:  EdgeInsets.only(top: h * 0.25,bottom: h * 0.15),
                                        decoration: BoxDecoration(
                                          color: startDateValue.isEmpty || Provider.of<DropDownSelection>(context, listen: false).selectedItemValue.isEmpty
                                          ? AppColors.opacityGreen
                                          : AppColors.lightGreen,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                          boxShadow: startDateValue.isEmpty || Provider.of<DropDownSelection>(context, listen: false).selectedItemValue.isEmpty
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
                                        child:  Center(
                                          child: Text(
                                            LocaleKeys.addEventButton.tr(context: context),
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
                                
                              ],
                            ),
                          );
                        }
                      ),
                      SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          width: w,
                          height: h,
                          child: Consumer<LifeEvent>(
                            builder: (context, data, child) {
                              var dateTime = DateTime.now();
                              DateTime dateWithoutTime = DateTime(dateTime.year,dateTime.month,dateTime.day);  
                              var todayList = data.lifeEvent.where((element) => dateWithoutTime.difference(DateTime.parse(element['start_date'])).inDays == 0).toList();
                              var yesterdayList = data.lifeEvent.where((element) => dateWithoutTime.difference(DateTime.parse(element['start_date'])).inDays == 1).toList();
                              var olderList = data.lifeEvent.where((element) => dateWithoutTime.difference(DateTime.parse(element['start_date'])).inDays > 1).toList();
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    if(todayList.isNotEmpty)...[
                                        Text(
                                          LocaleKeys.eventHistoryTodayTitle.tr(context: context),
                                           style: const TextStyle(
                                              color: AppColors.darkGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500
                                            ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        for(var x = 0; x < todayList.length; x++)
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            '${todayList[x]['notes']}',
                                            style: const TextStyle(
                                              color: AppColors.darkMov,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${DateTime.parse(todayList[x]['start_date']).day} ${DateFormat('MMM').format(DateTime.parse(todayList[x]['start_date']))}',
                                            style: const TextStyle(
                                                color: AppColors.darkGrey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500
                                              ),
                                          ),
                                          trailing: InkWell(
                                            onTap: () async{
                                              await showModalBottomSheet(
                                                backgroundColor: Colors.transparent,
                                                isScrollControlled: false,
                                                barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                                context: context,
                                                builder: (context) => deleteMessage(w,h,todayList[x]['id']),
                                              ); 
                                            },
                                            child: SvgPicture.asset(AppAssets.trash)
                                          ),
                                        ),
                                       Divider(color: AppColors.darkMov.withOpacity(0.3),),
                                    ],
                                    if(yesterdayList.isNotEmpty)...[
                                        const SizedBox(height: 15.0,),
                                         Text(
                                        LocaleKeys.eventHistoryYesterdayTitle.tr(context: context),
                                        style: const TextStyle(
                                              color: AppColors.darkGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500
                                            ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        for(var x = 0; x < yesterdayList.length; x++)
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Tooltip(
                                            textStyle: const TextStyle(color: AppColors.darkGrey),
                                            padding: const EdgeInsets.all(50),
                                            preferBelow: false,
                                            message: yesterdayList[x]['notes'].toString(),
                                            child: Text(
                                              truncateTitle(yesterdayList[x]['notes'].toString()),
                                              style: const TextStyle(
                                                color: AppColors.darkMov,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      
                                          subtitle: Text(
                                            '${DateTime.parse(yesterdayList[x]['start_date']).day} ${DateFormat('MMM').format(DateTime.parse(yesterdayList[x]['start_date']))}',
                                            style: const TextStyle(
                                                color: AppColors.darkGrey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400
                                              ),
                                          ),
                                          trailing: InkWell(
                                            onTap: () async{
                                              await showModalBottomSheet(
                                                backgroundColor: Colors.transparent,
                                                isScrollControlled: false,
                                                barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                                context: context,
                                                builder: (context) => deleteMessage(w,h,yesterdayList[x]['id']),
                                              ); 
                                            },
                                            child: SvgPicture.asset(AppAssets.trash)
                                          ),
                                        ),
                                      Divider(color: AppColors.darkMov.withOpacity(0.3),),
                                    ],
                                    if(olderList.isNotEmpty)...[
                                      const SizedBox(height: 15.0,),
                                        Text(
                                        LocaleKeys.eventHistoryOlderTitle.tr(context: context),
                                        style: const TextStyle(
                                              color: AppColors.darkGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400
                                            ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        for(var x = 0; x < olderList.length; x++)
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            '${olderList[x]['notes']}',
                                            style: const TextStyle(
                                              color: AppColors.darkMov,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${DateTime.parse(olderList[x]['start_date']).day} ${DateFormat('MMM').format(DateTime.parse(olderList[x]['start_date']))} ${DateTime.parse(olderList[x]['start_date']).year}',
                                            style: const TextStyle(
                                                color: AppColors.darkGrey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400
                                              ),
                                          ),
                                          trailing: InkWell(
                                            onTap: () async{
                                              await showModalBottomSheet(
                                                backgroundColor: Colors.transparent,
                                                isScrollControlled: false,
                                                barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
                                                context: context,
                                                builder: (context) => deleteMessage(w,h,olderList[x]['id']),
                                              ); 
                                            },
                                            child: SvgPicture.asset(AppAssets.trash)
                                          ),
                                        ),
                                    ],
                                    const SizedBox(height: 500,)
                                  ],
                                ),
                              );
                            }
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
        );
      }
    );
  }

  Widget deleteMessage(double w, double h, String lifeEventId) => Padding(
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
                     Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          LocaleKeys.eventHistoryDeleteDescription.tr(context: context),
                            style: const TextStyle(
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
                              await deleteEvent(context, lifeEventId);
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
                                  LocaleKeys.yes.tr(context: context),
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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:  Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            LocaleKeys.no.tr(context: context),
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
    Widget successMessage(double w, var h) => Padding(
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
                    SvgPicture.asset(AppAssets.eventSuccess),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                            LocaleKeys.addEventMessageSuccess.tr(context: context),
                            style: const TextStyle(
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
                            onTap: () async {
                              await resetAll(context);
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
                                  LocaleKeys.addEventMessageAddAnother.tr(context: context),
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
                  onTap: ()async{
                    await resetAll(context);
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