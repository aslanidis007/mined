import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mined/routes/routes.dart';
import '../../../constants/color.dart';
import '../select_ shapes.dart';

class Rounds extends StatefulWidget {
  final String title;
  final Widget page;
  const Rounds({super.key, required this.title, required this.page});

  @override
  State<Rounds> createState() => _RoundsState();
}

class _RoundsState extends State<Rounds> {
  final randomSeconds = Random().nextInt(5) + 1;

  @override
  void initState() {
    if(widget.page is SelectShapes){
      Future.delayed(const Duration(milliseconds: 1500), (){
        PageNavigator(ctx: context).nextPageOnly(page: widget.page);
      });
    }else{
      Future.delayed(Duration(seconds: randomSeconds), (){
        PageNavigator(ctx: context).nextPageOnly(page: widget.page);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: h * 0.25),
        width: w,
        height: h,
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 36.0,
                color: AppColors.darkMov,
                fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}