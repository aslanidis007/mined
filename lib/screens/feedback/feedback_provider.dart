import 'package:flutter/material.dart';
import '../../constants/color.dart';
import 'charts.dart';

class FeedbackProvider extends ChangeNotifier {
  List<List<DataPoint>> _chartsData = [];
  List<List<DataPoint>> get chartsData => _chartsData;
  final List<List<DataPoint>> _hideChartsData = [];
  List<List<DataPoint>> get hideChartsData => _hideChartsData;
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  showChartsValue(int chartsDataIndex) {
    if (chartsDataIndex >= 0 && chartsDataIndex < _chartsData.length) {

      List<DataPoint> dataToRemove = _chartsData[chartsDataIndex];

      if (_hideChartsData.contains(dataToRemove)) {
        _hideChartsData.remove(dataToRemove);
        notifyListeners();
      }
    }
  }

  hideChartsValue(int index) {
    _hideChartsData.add(_chartsData[index]);
    notifyListeners();
  }

  final getLineColor = [
    AppColors.mov,
    AppColors.orange,
    AppColors.green,
    AppColors.yellow
  ];

  fetchDataFromApi(List data, DateTime? date) async {
    _hideChartsData.clear();
    DateTime currentDate = date ?? DateTime.now();

    _endDate = currentDate;
    _startDate = DateTime(currentDate.year, currentDate.month - 3, currentDate.day);
    List<List<DataPoint>> dataSets = [];
    for (var i = 0; i < data.length; i++) {
      List<DataPoint> dataSet = [];
      for (var y = 0; y < data[i]['results'].length; y++) {
        var result = data[i]['results'][y];
        dataSet.add(DataPoint(DateTime.parse(result['completed']), result['score'],getLineColor[i]));
      }
      if(data[i]['results'].isNotEmpty){
        dataSets.add(dataSet);
      }
    }

    _chartsData = dataSets;
    notifyListeners();
  }
}