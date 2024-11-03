import 'package:flutter/material.dart';
import '../../constants/color.dart';

class ChartsTabs extends StatefulWidget {
  final List checkBoxList;
  const ChartsTabs({super.key, required this.checkBoxList});

  @override
  State<ChartsTabs> createState() => _ChartsTabsState();
}

class _ChartsTabsState extends State<ChartsTabs> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: widget.checkBoxList.length,
      child: Container(
        padding: EdgeInsets.only(left: w * 0.06),
        child: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: TabBar(
            indicatorPadding: const EdgeInsets.symmetric(vertical: 7), // Set the indicator padding here
            isScrollable: true,
            unselectedLabelColor: AppColors.lightGrey.withOpacity(0.3),
            labelColor: AppColors.darkMov,
            labelPadding: const EdgeInsets.symmetric(horizontal: 35),
            indicator: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.15),
                borderRadius: const BorderRadius.all(Radius.circular(40))
            ),
            tabs: [
              for(var x = 0;  x < widget.checkBoxList.length; x++)
              Tab(text: widget.checkBoxList[x].title,),
            ],
          ),
        ),
      ),
    );
  }
}
