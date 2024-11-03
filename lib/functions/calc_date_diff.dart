String calcDateDiff(String datetime) {
  final diffDuration = DateTime.parse(datetime).difference(DateTime.now());

  // Calculate days and hours separately
  int days = diffDuration.inDays;
  int hours = diffDuration.inHours.remainder(24);

  // Build the result string
  String resultDate = '';

  if (days > 0) {
    resultDate += '${days}d';
    if (hours > 0) {
      resultDate += ':';
    }
  }

  if (hours > 0 || days == 0) {
    resultDate += '${hours}h';
  }

  return resultDate.isEmpty ? 'Just now' : resultDate;
}