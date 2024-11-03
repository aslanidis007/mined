import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mined/constants/assets.dart';
import '../../constants/color.dart';

class BannedAlert extends StatefulWidget {
  const BannedAlert({super.key});

  @override
  State<BannedAlert> createState() => _BannedAlertState();
}

class _BannedAlertState extends State<BannedAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.ban),
              const SizedBox(height: 30,),
              const Text(
                  'Something is wrong with your \naccount.',
                style: TextStyle(
                  color: AppColors.darkMov,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15,),
              const Text(
                'Please contact support at \ninfo@mined',
                style: TextStyle(
                    color: AppColors.darkMov,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}