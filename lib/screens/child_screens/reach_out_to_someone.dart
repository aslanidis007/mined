import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/services/auth_system.dart';
import 'package:mined/services/dropdown_selection.dart';
import 'package:mined/services/talk_to_someone.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../helpers/dropdown.dart';

class ReachOutToSomeone extends StatefulWidget {
  const ReachOutToSomeone({super.key});

  @override
  State<ReachOutToSomeone> createState() => _ReachOutToSomeoneState();
}

class _ReachOutToSomeoneState extends State<ReachOutToSomeone> {
  TextEditingController reason = TextEditingController();
  bool visible = false;
  String eventValue = '';
  bool visibleTextArea = false;
  int? medicalId;
  List selected = [];
  final FocusNode _focusNode = FocusNode();

  clearSelections(context) async{
    reason.clear();
    await Provider.of<DropDownSelection>(context, listen: false).clearSelection();
    setState(() {
      _focusNode.unfocus();
      selected = [];
    });
    Navigator.pop(context);
  }
  sendTalkInfo(context, double w, h,String refereeId, String refereeClubId,String referralReason,String medicalId) async{
    String statusCode =  await Provider.of<TalkToSomeone>(context, listen: false).addTalkToSomeone(
      refereeId: refereeId,
      context: context,
      refereeClubId: refereeClubId,
      referralReason: referralReason,
      medicalId: medicalId,
      isAnonymous: false
    );
    if(statusCode == '200' || statusCode == '201'){
      await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: false,
          barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
          context: context,
          builder: (context) => sendHelp(w,h),
        ); 
      }
    }

  @override
  void initState() {
    Provider.of<TalkToSomeone>(context, listen:false).showMedical(context: context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Consumer<DropDownSelection>(
      builder: (context, item, child) {
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: (){
                                Provider.of<DropDownSelection>(context, listen: false).clearSelection();
                                Navigator.pop(context);
                              },
                              child: const Icon(FontAwesomeIcons.angleLeft,color: AppColors.white, size: 30,)),
                             Expanded(
                              child: Text(
                                LocaleKeys.reachOutToSomeoneTitle.tr(context: context),
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
                Padding(
                padding: const EdgeInsets.only(bottom: 25.0,top: 30.0),
                child: Text(
                  LocaleKeys.reachOutTosomeoneSelectionTitle.tr(context: context),
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
                padding: const EdgeInsets.only(left: 15),
                decoration:  BoxDecoration(
                  border: Border.all(color: AppColors.darkMov,width: 1.2),
                  borderRadius: const BorderRadius.all(Radius.circular(25))
                ),
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: reason,
                  minLines: 6, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    hintText: LocaleKeys.reachOutTosomeoneSelectionHint.tr(context: context),
                    hintStyle: const TextStyle(color: AppColors.lightMov)
                  ),
                ),
                  ),
               Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top:40.0),
                child: Text(
                  LocaleKeys.reachOutTosomeoneReachOutTitle.tr(context: context),
                    style: const TextStyle(
                      color: AppColors.darkMov,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              Consumer<TalkToSomeone>(
                builder: (context, data, child) {
                  for(var x = 0; x < data.medicalList.length; x++){
                    selected.add(false);
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.medicalList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            dropdownButton(
                              w: w,
                              h: h,
                              context: context,
                              data: data.medicalList,
                              typeDropdown: 'reachOutToSomeone',
                              selected: selected,
                              genderValue: ''
                            ),
                            SizedBox(height: h * 0.17,),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () async{ 
                                  String userId = await AuthSystem().getId();
                                  // ignore: use_build_context_synchronously
                                  await sendTalkInfo(
                                    context, 
                                    w, 
                                    h,
                                    userId,
                                    data.medicalList[index]['pivot']['club_id'],
                                    reason.text,
                                    data.medicalList[index]['id']
                                  );
                                },
                                child: Container(
                                  width: w * 0.8,
                                  height: 60.0,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: item.selectedItemValue.isEmpty || reason.text.isEmpty
                                    ? AppColors.opacityGreen
                                    :AppColors.lightGreen,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    boxShadow: item.selectedItemValue.isEmpty || reason.text.isEmpty
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
                                      LocaleKeys.reachOutTosomeoneButton.tr(context: context),
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
                        );
                      }
                    ),
                  );
                }
              ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.immedialHelpTitle.tr(context: context),
                        style: const TextStyle(
                          color: AppColors.lightMov,
                          fontSize: 14
                        )
                      ),
                      TextSpan(
                        text: '  ${LocaleKeys.tabHereTitle.tr(context: context)}',
                        style: const TextStyle(
                          color: AppColors.darkMov,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        )
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }


    Widget sendHelp(double w, var h) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            width: w,
            height: h * 0.65,
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
                    SvgPicture.asset(AppAssets.feedback),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                            LocaleKeys.thnksforReach.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                     Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Text(
                            LocaleKeys.medicalCallDescription.tr(context: context),
                            style: const TextStyle(
                              color: AppColors.lightMov,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
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
                            onTap: (){
                              clearSelections(context);                              
                            },
                            child: Container(
                              width: w * 0.8,
                              height: 65.0,
                              margin: const EdgeInsets.only(
                                top: 40
                              ),
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
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.immediateHelpTitle.tr(context: context),
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
                    clearSelections(context);
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