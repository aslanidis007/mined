import 'package:intl/intl.dart';

convertDatetime(DateTime dateTime){
  String date = '${DateFormat('dd').format(dateTime)}-${DateFormat('MM').format(dateTime)}-${DateFormat('yyyy').format(dateTime)}';
  return date;
}