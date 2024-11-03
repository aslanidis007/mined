import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constants/color.dart';
import '../../translations/locale_keys.g.dart';
import 'feedback_provider.dart';

class ChartsFeedback extends StatefulWidget {
  const ChartsFeedback({super.key});

  @override
  State<ChartsFeedback> createState() => _ChartsFeedbackState();
}

class _ChartsFeedbackState extends State<ChartsFeedback> {

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Consumer<FeedbackProvider>(
      builder: (context, prov, child) {
        List<List<DataPoint>> dataToShow = prov.chartsData
            .where((data) => !prov.hideChartsData.contains(data))
            .toList();
        if(prov.chartsData.isEmpty){
          return SizedBox(
            width: w,
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                labelAlignment: LabelAlignment.center,
                interval: 0.9,
                dateFormat: DateFormat('MMM'),
                initialVisibleMaximum: prov.endDate, // Set the maximum visible date
                initialVisibleMinimum: prov.startDate,
                plotBands: <PlotBand>[
                  PlotBand(
                    isVisible: false,
                    start: prov.startDate,
                    end: prov.endDate,
                    // shouldRenderAboveSeries: true,
                    color: const Color.fromRGBO(224, 155, 0, 1),
                  ),
                ],
              ),
              primaryYAxis: const NumericAxis(
                  minimum: 0,
                  maximum: 105
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: AppColors.mov,
                textStyle: const TextStyle(color: AppColors.white),
                builder: (dynamic dataPoint, dynamic series, dynamic logic,int pointIndex, int seriesIndex) {
                  // Customize the tooltip content here
                  return Container(
                    width: 100,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.mov, // Use your custom color
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${LocaleKeys.date.tr(context: context)}: ${DateFormat('dd MMM').format(dataPoint.x)}', style: const TextStyle(color: AppColors.white)),
                        Text('${LocaleKeys.score.tr(context: context)}: ${dataPoint.y}', style: const TextStyle(color: AppColors.white)),
                        // Add more information as needed
                      ],
                    ),
                  );
                },
              ),
              series: <SplineSeries>[
                for(var x = 0; x < dataToShow.length; x++)
                  SplineSeries(
                    splineType: SplineType.monotonic,
                    width: 2.2,
                    color: dataToShow[x][0].color,
                    dataSource: dataToShow[x],
                    xValueMapper: (date,_) => date.x,
                    yValueMapper: (score, _) => score.y,
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
              ],
            ),
          );
        }
        return SizedBox(
          width: w,
          height: 200,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              labelAlignment: LabelAlignment.center,
              interval: 1,
              dateFormat: DateFormat('MMM'),
              minimum: prov.endDate, // Set the maximum visible date
              maximum: prov.startDate,
            ),
            primaryYAxis: const NumericAxis(
              minimum: 0,
              maximum: 105,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              textStyle: const TextStyle(color: AppColors.white),
              builder: (dynamic dataPoint, dynamic series, dynamic logic,int pointIndex, int seriesIndex) {
                return Container(
                  width: 100,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.lightMov),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${LocaleKeys.date.tr(context: context)}: ${DateFormat('dd MMM').format(dataPoint.x)}', style: const TextStyle(color: AppColors.darkMov)),
                      Text('${LocaleKeys.score.tr(context: context)}: ${dataPoint.y}', style: const TextStyle(color: AppColors.darkMov)),
                      // Add more information as needed
                    ],
                  ),
                );
              },
            ),
            series: <SplineSeries>[
              for(var x = 0; x < dataToShow.length; x++)
              SplineSeries(
                splineType: SplineType.monotonic,
                cardinalSplineTension: 1,
                width: 2.2,
                color: dataToShow[x][0].color,
                dataSource: dataToShow[x],
                xValueMapper: (date,_) => date.x,
                yValueMapper: (score, _) => score.y,
                markerSettings: MarkerSettings(isVisible: true, color: dataToShow[x][0].color),
              ),
            ],
          ),
        );
      }
    );
  }
}
class DataPoint {
  DataPoint(this.x, this.y, this.color);

  DateTime x;
  final int y;
  Color color;
}