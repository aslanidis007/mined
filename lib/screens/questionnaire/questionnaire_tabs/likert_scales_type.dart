import 'package:flutter/material.dart';
import 'package:mined/services/selection_mechanism.dart';
import 'package:provider/provider.dart';
import '../../../constants/color.dart';
import '../../../services/selection_list.dart';

class LikertScalesType extends StatelessWidget {
  final String title;
  final List responseOptions;
  final int indexList;
  const LikertScalesType({super.key, required this.title, required this.responseOptions, required this.indexList});

  @override
  Widget build(BuildContext context) {
    final selection = Provider.of<AnswerSelection>(context);
    final responseData = Provider.of<ResponseModel>(context);

    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.darkMov,
              fontSize: 24,
              fontWeight: FontWeight.w700
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              width: w,
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: responseOptions.length,
                itemBuilder: (context, index){
                  int questionId = responseOptions[index]['question_id'];
                  int optionId = responseOptions[index]['id'];

                  // Check if the option is selected for this question
                  bool isSelected = false;
                  if (selection.choose.containsKey(questionId)) {
                    isSelected = selection.choose[questionId]!.any((selected) =>
                        selected.index == optionId);
                  }
                  return GestureDetector(
                    onTap: () {
                      selection.setChoose(
                        questionId,
                        optionId,
                        false
                      );
                      responseData.setResponse(
                        questionId, 
                        optionId, 
                        responseOptions[index]['label'], 
                        responseOptions[index]['value'],
                        null,
                        false
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(bottom: 10,),
                          decoration: BoxDecoration(
                              color: isSelected == true ? AppColors.darkMov : AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.lightMov)
                          ),
                        ),
                        const SizedBox(width: 5,),
                        SizedBox(
                          width: responseOptions.length < 5 ?  w * 0.20 : w * 0.16,
                          child: Text(
                            responseOptions[index]['label'],
                            style: const TextStyle(
                              color:AppColors.darkMov,
                              fontSize: 12
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}