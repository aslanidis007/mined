import 'package:flutter/material.dart';
import 'package:mined/routes/screening_route.dart';
import 'package:mined/screens/questionnaire/questionnaire_tabs/free_text.dart';
import 'package:mined/screens/questionnaire/questionnaire_tabs/likert_scales_type.dart';
import 'package:mined/screens/questionnaire/questionnaire_tabs/multiple_choice.dart';
import 'package:mined/screens/questionnaire/questionnaire_tabs/single_choice.dart';
import 'package:mined/screens/questionnaire/questionnaire_tabs/yes_or_no_type.dart';
import 'package:mined/services/user_tasks.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import '../../services/selection_list.dart';
import '../../services/selection_mechanism.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final PageController _pageController = PageController(initialPage: 0);
  double indicatorValue = 0.0;
  int currentPage = 0;
  int taskLength = 0;

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  loadTaskLength() async{
    taskLength  =  Provider.of<Tasks>(context, listen: false).taskItem['task']['questions'].length;
    setState(() {});
  }

  completeTaskItemAndCheckForNextStep(context)async{
    final result = await Provider.of<Tasks>(context, listen: false).completeTaskItem(
      assignedTaskItemId: Provider.of<Tasks>(context, listen: false).taskItem['id'], 
      taskList: Provider.of<ResponseModel>(context, listen: false).responses,
      context: context
    );
    if(result.isNotEmpty){
      ScreeningRoute(ctx: context).viewNextScreen(hasNext: result['next_step']);
    }
  }

  @override
  void initState() {
    Provider.of<ResponseModel>(context, listen: false);
    loadTaskLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white.withOpacity(0.95),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: h * 0.06, bottom: 25.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Provider.of<AnswerSelection>(context, listen: false).resetChoose();
                      Provider.of<AnswerSelection>(context, listen: false).resetSelection();
                      Provider.of<ResponseModel>(context, listen: false).resetResponses();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close, 
                      size: 38, 
                      color: AppColors.lightMov,
                    ),
                  ),
                  SizedBox(width: w * 0.15,),
                    Text(
                      Provider.of<Tasks>(context, listen: false).taskItem['task']['name'],
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Container(
                width: w,
                height: h,
                padding: EdgeInsets.only(top: h * 0.05),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Consumer<Tasks>(
                    builder: (context, data, child) {
                      return Column(
                        children:[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${currentPage+1}/$taskLength',
                                style: TextStyle(
                                  color: AppColors.lightMov.withOpacity(0.9)
                                ),
                              ),
                              const SizedBox(height: 5,),
                              LinearProgressIndicator(
                                color: AppColors.lightGreen,
                                value: (currentPage+1)/taskLength,
                                backgroundColor: AppColors.lightMov.withOpacity(0.15),
                                minHeight: 5,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                            Expanded(
                              child: PageView.builder(
                                onPageChanged: _onPageChanged,
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: data.taskItem['task']['questions'].length,
                                itemBuilder: (context, index){
                                  if(data.taskItem['task']['questions'][index]['type'] == 'LIKERT'){
                                  return LikertScalesType(
                                    title: '${data.taskItem['task']['questions'][index]['body']}',
                                    responseOptions: data.taskItem['task']['questions'][index]['response_options'],
                                    indexList: index,
                                  );
                                  } else if(data.taskItem['task']['questions'][index]['type'] == 'YES_NO'){
                                    return YesOrNo(
                                      title: '${data.taskItem['task']['questions'][index]['body']}',
                                      responseOptions: data.taskItem['task']['questions'][index]['response_options'],
                                      indexList: index,
                                    );
                                  } else if(data.taskItem['task']['questions'][index]['type'] == 'FREE_TEXT'){
                                    return FreeTextType(
                                      title: '${data.taskItem['task']['questions'][index]['body']}',
                                      responseOptions: data.taskItem['task']['questions'][index],
                                    );
                                  } else if(data.taskItem['task']['questions'][index]['type'] == 'MULTIPLE_CHOICE'){
                                    return MultipleChoice(
                                      title: '${data.taskItem['task']['questions'][index]['body']}',
                                      responseOptions: data.taskItem['task']['questions'][index]['response_options'],
                                      indexList: index,
                                    );
                                  }else if (data.taskItem['task']['questions'][index]['type'] == 'SINGLE_CHOICE'){
                                    return SingleChoice(
                                      title: '${data.taskItem['task']['questions'][index]['body']}',
                                      responseOptions: data.taskItem['task']['questions'][index]['response_options'],
                                      indexList: index,
                                    );                                
                                  }else{
                                    return null;
                                  }
                                }
                              ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: h * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      Consumer<AnswerSelection>(
                        builder: (context, prod, child) {
                          if(prod.isSelected == true) {
                            return Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (currentPage > 0) {
                                        setState(() {
                                          _pageController.animateToPage(
                                              currentPage - 1,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut);
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 50,
                                          top: 15,
                                          right: 50,
                                          bottom: 15),
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                              color: AppColors.lightGreen,
                                              width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40))
                                      ),
                                      child: const Text(
                                        'Back',
                                        style: TextStyle(
                                            color: AppColors.darkMov,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Provider.of<AnswerSelection>(context, listen: false).resetSelection();
                                      if (currentPage < Provider.of<Tasks>(context, listen: false).taskItem['task']['questions'].length - 1) {
                                        setState(() {
                                          _pageController.animateToPage(
                                              currentPage + 1,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut);
                                          currentPage;
                                        });
                                        // await Provider.of<AnswerSelection>(context,listen: false).resetSelection();
                                      } else {
                                        await completeTaskItemAndCheckForNextStep(context);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 50,
                                          top: 15,
                                          right: 50,
                                          bottom: 15),
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                              color: AppColors.lightGreen,
                                              width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40))
                                      ),
                                      child: Text(
                                        currentPage < Provider
                                            .of<Tasks>(context, listen: false)
                                            .taskItem['task']['questions']
                                            .length - 1
                                            ? 'Next' : 'Done',
                                        style: const TextStyle(
                                            color: AppColors.darkMov,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                            );
                          }else{
                            return Container(color: AppColors.white,);
                          }
                        }
                      ),
                  ],
                )
              ),
            )
          ),
        ],
      ),
    );
  }
}