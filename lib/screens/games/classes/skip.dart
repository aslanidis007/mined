import 'package:flutter/material.dart';
import 'package:mined/screens/games/classes/count_time.dart';

import '../../../constants/color.dart';
import '../service/round_counter.dart';

Widget skipRound({
  required BuildContext context,
  required RoundCounter prov,
  required Widget page,
}){
  return Positioned(
    top: 55,
    right: 10,
    child: InkWell(
      onTap: () {
        CountTime.updateCounterAndNavigate(context, prov, 0, page, 6, true);
      },
      child: const Row(
        children: [
          Text(
            'Skip',
            style: TextStyle(
              color: AppColors.darkMov,
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          ),
          Icon(Icons.skip_next),
        ],
      ),
    ),
  );
}