import 'package:flutter/material.dart';
import 'package:mined/screens/games/classes/count_time.dart';
import 'package:mined/screens/games/service/round_counter.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import 'classes/exit_game.dart';
import 'pages/result_time.dart';

class NumberBySeries extends StatefulWidget {
  final String title;
  final String body;
  const NumberBySeries({super.key, required this.title, required this.body});

  @override
  State<NumberBySeries> createState() => _NumberBySeriesState();
}

class _NumberBySeriesState extends State<NumberBySeries> {
  List<int> numbersList = List<int>.generate(16, (i) => i + 1);
  List<int> correctList = List<int>.generate(10, (i) => i + 1);
  List<int> userSelection = [];
  List<bool> selected = List<bool>.filled(16, false);
  List<bool> selectedWrong = List<bool>.filled(16, false);
  int counter = 0;
  double userSeconds = 0.0;
  int failedAttemptsCount = 0;

  void successState(int value){
    if (!mounted) return;
    setState(() {
      userSelection.add(value);
      counter++;
    });
  }

  void wrongState(int index){
    if (!mounted) return;
    setState(() {
      failedAttemptsCount++;
      selected[index] = false;
      selectedWrong[index] = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        selectedWrong[index] = false;
      });
    });
  }

  void addUserInputAsc(int userInput, int index) {
    if(userSelection.isEmpty){
      if(userInput == 1){
        successState(userInput);
      }else{
        wrongState(index);
      }
    }else if (userInput - userSelection[counter - 1] == 1){
      successState(userInput);
    }else{
      wrongState(index);
    }
  }
  void addUserInputDesc(int userInput, int index) {
    if(userSelection.isEmpty){
      if(userInput == 10){
        successState(userInput);
      }else{
        wrongState(index);
      }
    }else if (userInput - userSelection[counter - 1] == -1){
      successState(userInput);
    }else{
      wrongState(index);
    }
  }

  @override
  void initState() {
    CountTime.startTimer();
    numbersList.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<RoundCounter>(
        builder: (context, prov, child) {
          return Stack(
            children: [
              exitGame(
                title: widget.title,
                body: widget.body,
                page: NumberBySeries(title: widget.title, body: widget.title),
                context: context
              ),
              Container(
                width: w,
                height: h,
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 100.0),
                child: Column(
                  children: [
                    if(prov.counter == 0)...[
                      const Text(
                        'Select numbers 1-10 in ascending order.',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]else...[
                      const Text(
                        'Select numbers 10-1 in descending order.',
                        style: TextStyle(
                          color: AppColors.darkMov,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 25.0, // Adjust the spacing as needed
                          mainAxisSpacing: 25.0,
                        ),
                        itemCount: numbersList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if(!selected[index] && userSelection.length < 10){
                                if (!selectedWrong.any((element) => element == true)) {
                                  setState(() {
                                    selected[index] = true;
                                    prov.counter == 1 
                                      ? addUserInputDesc(numbersList[index], index) 
                                      : addUserInputAsc(numbersList[index], index);
                                  });
                                  if(!prov.endgame && userSelection.length == 10){
                                    CountTime.updateCounterAndNavigate(context, prov, failedAttemptsCount, NumberBySeries(title: widget.title, body: widget.body,), 2, false);
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: selectedWrong[index] ? AppColors.screenRed : AppColors.numberUnselectedColor,
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                    color: selected[index] == true
                                        ? AppColors.mov
                                        : selectedWrong[index]
                                            ? AppColors.red
                                            : AppColors.lightMov.withOpacity(0.2),
                                    spreadRadius: 0.0,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ), // Add your styling here
                              child: Center(
                                child: Text(
                                  numbersList[index].toString(),
                                  style: TextStyle(
                                    color: selected[index] == true
                                        ? AppColors.mov
                                        : selectedWrong[index]
                                            ? AppColors.red
                                            : AppColors.darkMov,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
               ResultTime(prov: prov,),
            ],
          );
        }
      ),
    );
  }
}
