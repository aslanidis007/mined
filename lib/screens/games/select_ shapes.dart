import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mined/constants/assets.dart';
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import 'classes/count_time.dart';
import 'classes/exit_game.dart';
import 'pages/result_time.dart';
import 'service/round_counter.dart';

class SelectShapes extends StatefulWidget {
  final String title;
  final String body;
  const SelectShapes({super.key, required this.title, required this.body});

  @override
  State<SelectShapes> createState() => _SelectShapesState();
}

class _SelectShapesState extends State<SelectShapes> {
  List<String> shapes = ['circle','exclamation mark','square','triangle','star','cross','question mark'];
  List<String> addShapes = [];
  String? randomSelectShape;
  List<bool> selected = List<bool>.filled(4, false);
  List<bool> selectedWrong = List<bool>.filled(4, false);
  int counter = 0;
  int failedAttemptsCount = 0;

  void setWrongPress(int index){
    setState(() {
      selectedWrong[index] = true;
    });
    Future.delayed(const Duration(milliseconds: 700), (){
      setState(() {
        failedAttemptsCount++;
        selectedWrong[index] = false;
      });
    });
  }
  
  void correctAnswer(int index,RoundCounter prov){
    setState(() {
      selected[index] = true;
    });
    Future.delayed(const Duration(milliseconds: 500), (){
      CountTime.updateCounterAndNavigate(context, prov, failedAttemptsCount, SelectShapes(title: widget.title, body: widget.body,), prov.roundNumber, false);
      setState(() {
        selected[index] = false;
      });
    });
  }


getShape() {
  var random = Random();
  shapes.shuffle(); // Shuffle the list of shapes
  addShapes = shapes.toSet().take(4).toList(); // Take the first four unique shapes
  randomSelectShape = addShapes[random.nextInt(4)];
  setState(() {});
}

  @override
  void initState() {
    CountTime.startTimer();
    getShape();
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
                page: SelectShapes(title: widget.title, body: widget.title),
                context: context
              ),
              Container(
                width: w,
                height: h,
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 100.0),
                child: Column(
                  children: [
                    Text(
                      'Select the ${randomSelectShape ?? ''}.',
                      style: const TextStyle(
                        color: AppColors.darkMov,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 90.0,),
                    Row(
                      children: [
                        shapesContainer(0, prov),
                        const Spacer(),
                        shapesContainer(1, prov),
                      ],
                    ),
                    const SizedBox(height: 40.0,),
                    Row(
                      children: [
                        shapesContainer(2, prov),
                        const Spacer(),
                        shapesContainer(3, prov),
                      ],
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

  Widget shapesContainer(int index,RoundCounter prov){
    return Stack(
      children: [
        GestureDetector(
          onTap: (){ 
            if(!selectedWrong.any((element) => element == true)){
              if(addShapes[index] == randomSelectShape){
                correctAnswer(index, prov);
              }else{
                setWrongPress(index);
              }
            }     
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              boxShadow: [
                if(selectedWrong[index] == true && selected[index] == false)...[
                  const BoxShadow(
                    color: AppColors.grey,
                    offset: Offset(0, 3),
                    blurRadius: 10.0,
                    spreadRadius: 8.0
                  )
                ]else if(selectedWrong[index] == false && selected[index] == true)...[
                  const BoxShadow(
                    color: AppColors.grey,
                    offset: Offset(0, 3),
                    blurRadius: 10.0,
                    spreadRadius: 8.0
                  )
                ]
              ],
              borderRadius: const BorderRadius.all(Radius.circular(18.0)),
              color:AppColors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  gestShapeImage(addShapes[index]),
                  fit: BoxFit.cover, // Optional: Adjust the fit as needed
                  placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(20.0),
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
        if(selectedWrong[index] == true && selected[index] == false)...[
          Positioned(
            top: 10,
            right: 10,
            child: SvgPicture.asset(AppAssets.fail)
          ),
        ]else if(selectedWrong[index] == false && selected[index] == true)...[
          Positioned(
            top: 10,
            right: 10,
            child: SvgPicture.asset(AppAssets.check,)
          )
        ]
      ],
    );
  }
  gestShapeImage(String name){
    switch (name) {
      case 'circle':
        return AppAssets.circle;
      case 'exclamation mark':
        return AppAssets.exclamationMark;
      case 'square':
        return AppAssets.square;
      case 'triangle':
        return AppAssets.triangle;
      case 'star':
        return AppAssets.startGame;
      case 'cross':
        return AppAssets.cross;
      case 'question mark':
        return AppAssets.questionMark;
      default:
        return AppAssets.questionMark;
    }
  }
}