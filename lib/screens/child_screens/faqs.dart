import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../widgets/header.dart';


class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Widgets.header(context, w, h, 'Help'),
          const SizedBox(height: 30,),
          const Text(
            'FAQs',
            style: TextStyle(
              color: AppColors.darkMov,
              fontSize: 24,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 15,),
          const ExpansionTile(
            title: Text('Question 1'),
            children: [
              ListTile(
                title: Text('Lorem ipsum dolor sit amet consectetur. Tellus massa mattis non sed neque vestibulum. Etiam sit urna egestas pretium in. Nunc pretium diam aliquam ligula et urna.'),
              )
            ],
          ),
          const ExpansionTile(
            title: Text('Question 2'),
            children: [
              ListTile(
                title: Text('Lorem ipsum dolor sit amet consectetur. Tellus massa mattis non sed neque vestibulum. Etiam sit urna egestas pretium in. Nunc pretium diam aliquam ligula et urna.'),
              )
            ],
          ),
          const ExpansionTile(
            title: Text('Question 3'),
            children: [
              ListTile(
                title: Text('Lorem ipsum dolor sit amet consectetur. Tellus massa mattis non sed neque vestibulum. Etiam sit urna egestas pretium in. Nunc pretium diam aliquam ligula et urna.'),
              )
            ],
          ),
           Expanded(
            child: Align(
              alignment: Alignment.bottomCenter, 
              child: Container(
                width: w,
                height: 90,
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightMov.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 30,
                      offset: const Offset(0,8)
                    )
                  ],
                ),
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      text: 'Still need help  ',
                      style: TextStyle(
                        color: AppColors.lightMov,
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                      ),
                      children: [
                        TextSpan(
                          text: ' Contact us',
                          style: TextStyle(
                            color: AppColors.darkMov,
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          )
                        )
                      ]
                    ),
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}