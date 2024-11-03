import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/services/talk_to_someone.dart';
import 'package:mined/services/team_mate.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../../helpers/dropdown.dart';
import '../../services/dropdown_selection.dart';
import '../../services/leave_feedback.dart';

class TeamatePerson extends StatefulWidget {
  final String fullName;
  final String userId;
  const TeamatePerson({super.key,required this.fullName, required this.userId});

  @override
  State<TeamatePerson> createState() => _TeamatePersonState();
}

class _TeamatePersonState extends State<TeamatePerson> {
  TextEditingController reason = TextEditingController();
  bool visible = false;
  String eventValue = '';
  bool visibleTextArea = false;
  int? medicalId;
  List selected = [];
  bool checkedValue = false;
  final FocusNode _focusNode = FocusNode();

  clearSelections(context) async{
    reason.clear();
    await Provider.of<DropDownSelection>(context, listen: false).clearSelection();
    setState(() {
      _focusNode.unfocus();
      eventValue = '';
      checkedValue = false;
      selected = [];
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }
  sendTalkInfo(context, double w, h, String refereeClubId,String referralReason,String medicalId, bool isAnonymous) async{
    String statusCode =  await Provider.of<TalkToSomeone>(context, listen: false).addTalkToSomeone(
      context: context,
      refereeId: widget.userId,
      refereeClubId: refereeClubId,
      referralReason: referralReason,
      medicalId: medicalId,
      isAnonymous: checkedValue
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
    Provider.of<LeaveFeedBackService>(context, listen:false).showFeedback(context: context);
    Provider.of<TeamMateProvider>(context, listen:false).teamMateMedical(user: widget.userId,context: context);
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
                    padding: const EdgeInsets.only(top: 65.0, left: 20.0, right: 50.0),
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
                                widget.fullName,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 25.0,top: 30.0),
                      child: Text(
                        'Add reason for referral',
                        style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Container(
                      width: w * 0.85,
                      height: 90,
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
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Summarise the reason',
                            hintStyle: TextStyle(color: AppColors.lightMov)
                        ),
                      ),
                    ),
                
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15.0, top:40.0),
                      child: Text(
                        'Select medical contact',
                        style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ],
                ),
              Consumer<TeamMateProvider>(
                builder: (context, data, child) {
                for(var x = 0; x < data.medical.length; x++){
                  selected.add(false);
                }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.medical.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            dropdownButton(
                              w: w,
                              h: h,
                              context: context,
                              data: data.medical,
                              typeDropdown: 'teammate',
                              selected: selected,
                              genderValue: ''
                            ),
                      SizedBox(
                        width: w * 0.85,
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
                              text: const TextSpan(
                                text: 'I want to remain anonymous',
                                style: TextStyle(
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
                            SizedBox(height: h * 0.18,),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () async{
                                  await sendTalkInfo(
                                    context, 
                                    w, 
                                    h,
                                    data.medical[index]['pivot']['club_id'],
                                    reason.text,
                                    data.medical[index]['id'],
                                    checkedValue
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
                                  child: const Center(
                                    child: Text(
                                      'Refer teammate',
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
                          ],
                        );
                      }
                    ),
                  );
                }
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
            height: h * 0.9,
            padding: const EdgeInsets.only(top: 20),
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
                    SvgPicture.asset(AppAssets.teammate),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                            '${widget.fullName} has been \nsuccessfully referred.',
                            style: const TextStyle(
                              color: AppColors.darkMov,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Text(
                            'Thanks for spreading the word and helping \nothers! Keep referring team members who \nneed help.',
                            style: TextStyle(
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
                            onTap: () async{
                             await clearSelections(context);
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
                              child: const Center(
                                child: Text(
                                  'Refer someone else',
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
                  ),
                ),
              ),
            ),
             Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
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
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 30,
                    color: AppColors.lightMov,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
}