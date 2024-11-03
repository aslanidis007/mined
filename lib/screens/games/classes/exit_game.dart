import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';
import '../../../routes/routes.dart';
import '../pages/start_game.dart';
import '../service/round_counter.dart';

Widget exitGame({
    required String title,
    required String body,
    required Widget page,
    required BuildContext context
  }){
  return Positioned(
    top: 55,
    left: 10,
    child: GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: false,
          barrierColor: AppColors.dipDarkMov.withOpacity(0.9),
          context: context,
          builder: (context) => deleteMessage(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height,context,page,title,body),
        ); 
      },
      child: const Column(
        children: [
          Icon(Icons.close, size: 30,),
        ],
      ),
    ),
  );
}

  Widget deleteMessage(double w, double h, BuildContext context, Widget page, String title, String body) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Stack(
      children: [
        Container(
          width: w,
          height: h * 0.42,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                          'If you quit now all progress on this \nexcersise will be lost.\nAre you sure you want to quit?',
                          style: TextStyle(
                            color: AppColors.darkMov,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
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
                            Provider.of<RoundCounter>(context, listen:false).resetCounter();
                            PageNavigator(ctx: context).nextPageOnly(page: StartGame(page: page,title: title,body: body));
                          },
                          child: Container(
                            width: w * 0.8,
                            height: 50.0,
                            margin: const EdgeInsets.only(top: 30),
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
                                )
                              ]
                            ),
                            child: const Center(
                              child: Text(
                                'Yes',
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
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: AppColors.lightMov,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),
                      ),
                    )
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
                  Navigator.pop(context);
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