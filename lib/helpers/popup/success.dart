import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/color.dart';

Widget successMessage(
  {
    required BuildContext context,
    required double w,
    required double h,
    required Color titleColor,
    required String image,
    required String btnName,
    required String title,
  }) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Stack(
      children: [
        Container(
          width: w,
          height: h * 0.5,
          padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
              color: Colors.transparent,
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 70),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                color: AppColors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  SvgPicture.asset(image),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                          title,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: w * 0.8,
                            height: 65.0,
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
                            child: Center(
                              child: Text(
                                btnName,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
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