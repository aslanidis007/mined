import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/color.dart';
import '../../../services/selection_list.dart';
import '../../../services/selection_mechanism.dart';

class FreeTextType extends StatefulWidget {
  final String title;
  final Map responseOptions;
  const FreeTextType({super.key, required this.title, required this.responseOptions});

  @override
  State<FreeTextType> createState() => _FreeTextTypeState();
}

class _FreeTextTypeState extends State<FreeTextType> {
    TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final responseData = Provider.of<ResponseModel>(context);
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
                widget.title,
                style: const TextStyle(
                  color: AppColors.darkMov,
                  fontSize: 24,
                  fontWeight: FontWeight.w700
                ),
              ),
              Container(
                width: w * .9,
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lightMov, width: 1)
                ),
                child: TextFormField(
                  controller: textController,
                  onChanged: (value){   
                    if(value.isNotEmpty){                 
                      responseData.setResponse(
                        widget.responseOptions['questionnaire_id'], 
                        widget.responseOptions['id'],
                        widget.responseOptions['body'], 
                        null,
                        value,
                        false
                      );
                      Provider.of<AnswerSelection>(context, listen: false).setSelectedTrue();
                    }else{
                      Provider.of<AnswerSelection>(context, listen: false).resetSelection();
                    }
                  },
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Type your answer here.'
                    ),
                  minLines: 8, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}