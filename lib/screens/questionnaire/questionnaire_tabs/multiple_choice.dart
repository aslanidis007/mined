import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/color.dart';
import '../../../services/selection_list.dart';
import '../../../services/selection_mechanism.dart';

class MultipleChoice extends StatelessWidget {
  final String title;
  final List responseOptions;
  final int indexList;
  const MultipleChoice({super.key, required this.title, required this.responseOptions, required this.indexList});

  @override
  Widget build(BuildContext context) {
    final selection = Provider.of<AnswerSelection>(context);
    final responseData = Provider.of<ResponseModel>(context);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: w,
          height: h,
          child: Column(
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
              Expanded(
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  itemCount: responseOptions.length,
                  itemBuilder: (context, index) {
                    int questionId = responseOptions[index]['question_id'];
                    int optionId = responseOptions[index]['id'];

                    // Check if the option is selected for this question
                    bool isSelected = false;
                    if (selection.choose.containsKey(questionId)) {
                      isSelected = selection.choose[questionId]!.any((selected) =>
                          selected.index == optionId);
                    }
                    return GestureDetector(
                      onTap: (){
                        selection.setChoose(
                          questionId,
                          optionId,
                          true
                        );
                        responseData.setResponse(
                          questionId, 
                          optionId, 
                          responseOptions[index]['label'], 
                          responseOptions[index]['value'],
                          null,
                          true
                        );
                      },
                      child: Container(
                        width: w * .9,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected == true ? AppColors.darkMov : AppColors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: AppColors.lightMov, width: 1)
                        ),
                        child: Text(
                          responseOptions[index]['label'],
                          style: TextStyle(
                            color: isSelected == true ?AppColors.white : AppColors.lightMov,
                            fontSize: 16
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}