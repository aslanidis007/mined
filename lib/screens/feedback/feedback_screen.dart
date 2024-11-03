import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mined/helpers/month_per_index.dart';
import 'package:mined/screens/feedback/feedback_provider.dart';
import 'package:mined/screens/feedback/tabs.dart';
import 'package:mined/services/leave_feedback.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import '../../helpers/convert_date.dart';
import '../widgets/header.dart';
import 'charts.dart';

class FeedbackScreen extends StatefulWidget {
  final String title;
  final int index;
  const FeedbackScreen({super.key, required this.title, required this.index});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List checkBoxList = [];

  loadFeedBackData({required context, DateTime? selectedDate}) async{
    String date = await convertDatetime(selectedDate ?? DateTime.now());
    await Provider.of<LeaveFeedBackService>(context, listen: false).showFeedBackArea(
      context: context, 
      areaId: widget.index, 
      date: date
    );
    List result = Provider.of<LeaveFeedBackService>(context, listen: false).feedBackArea;
    await Provider.of<FeedbackProvider>(context, listen: false).fetchDataFromApi(result,selectedDate);

    for(var x = 0; x < result.length; x++){
      checkBoxList.add(CheckBoxModel(title: result[x]['title']));
    }
    setState(() {checkBoxList = checkBoxList;});
  }

  @override
  void initState() {
    loadFeedBackData(context:context);
    super.initState();
  }

  final _getLineColor = [
    AppColors.mov,
    AppColors.orange,
    AppColors.green,
    AppColors.yellow
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: w,
          height: h,
          child: Consumer<FeedbackProvider>(
             builder: (context, prov, child) {
              if(prov.startDate == null || prov.endDate == null || prov.chartsData.isEmpty){
                return Center(
                  child: Column(
                    children: [
                      Widgets.header(context,w,h,widget.title),
                      const Spacer(),
                      const Text(
                        'Feedback is empty!',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontSize: 22.0,
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white
                    ),
                    child: Column(
                      children: [
                        Widgets.header(context,w,h,widget.title),
                      ],
                    ),
                  ),
                  Container(
                    width: w * 0.85,
                    height: h * 0.47,
                    margin: EdgeInsets.only(top: h * 0.08),
                    padding: EdgeInsets.symmetric(vertical: h * 0.025),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey, width: 2),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: h * 0.02),
                          child: Row(
                            children: [
                             GestureDetector(
                              onTap:() async{
                                await loadFeedBackData(
                                  context: context,
                                  selectedDate: DateTime(prov.endDate!.year, prov.endDate!.month - 1, prov.endDate!.day)
                                );
                              },
                               child: const Icon(
                                  FontAwesomeIcons.angleLeft,
                                  color: AppColors.lightMov,
                                  size: 18,
                                ),
                             ),
                              const SizedBox(width: 20,),
                              Text(
                                '${prov.startDate!.day} ${getMonthLabel(prov.startDate!.month)} - ${prov.startDate!.day} ${getMonthLabel(prov.endDate!.month)}',
                                style: const TextStyle(
                                  color: AppColors.lightMov,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              const Spacer(),
                              if(prov.endDate!.month != DateTime.now().month)...[
                                GestureDetector(
                                  onTap: () async{
                                    await loadFeedBackData(
                                      context: context,
                                      selectedDate: DateTime(prov.endDate!.year, prov.endDate!.month + 1, prov.endDate!.day)
                                    );
                                  },
                                  child: const Icon(
                                    FontAwesomeIcons.angleRight,
                                    color: AppColors.lightMov,
                                    size: 18,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                        const SizedBox(height: 25.0,),
                        // const ChartsFeedback(),
                        const ChartsFeedback(),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: prov.chartsData.length,
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 1,
                              mainAxisExtent: 50,
                              crossAxisCount: 2
                            ),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () async{
                                  questionnaireClicked(checkBoxList[index]);
                                  if(!checkBoxList[index].isActive){
                                     prov.hideChartsValue(index);
                                  }else{
                                    prov.showChartsValue(index);

                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                                minLeadingWidth: 0,
                                minVerticalPadding: 0,
                                leading: Transform.scale(
                                  scale: 0.65,
                                  child: Checkbox(
                                    activeColor: _getLineColor[index],
                                    side: MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(width: 1.0, color: _getLineColor[index]),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    checkColor: Colors.transparent,
                                    value: checkBoxList.isEmpty ? false :checkBoxList[index].isActive,
                                    onChanged: (value) async{
                                      questionnaireClicked(checkBoxList[index]);
                                      if(!checkBoxList[index].isActive){
                                        prov.hideChartsValue(index);
                                      }else{
                                          prov.showChartsValue(index);

                                      }
                                    }
                                  ),
                                ),
                                title: Transform.translate(
                                  offset: const Offset(-28,0),
                                  child: Text(
                                    checkBoxList.isEmpty ? '' : checkBoxList[index].title!,
                                    style: const TextStyle(
                                      color: AppColors.lightMov,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      ],
                    )
                  ),
                  checkBoxList.isEmpty 
                    ? Container()
                    : ChartsTabs(checkBoxList: checkBoxList,)
                ],
              );
            }
          ),
        ),
      )
    );
  }

  questionnaireClicked(CheckBoxModel chkItem){
    setState(() {
      chkItem.isActive = !chkItem.isActive;
    });
  }
}
class CheckBoxModel{
  String? title;
  bool isActive;

  CheckBoxModel({@required this.title, this.isActive = true});
}