String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    // If the date is today, show the time difference
    Duration difference = now.difference(dateTime);
    if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  } else {
    // If the date is older, show the formatted date
    return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}, ${_formatTime(dateTime)}';
  }
}
String getDateStatus(DateTime dateTime) {
  DateTime now = DateTime.now();
  
  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return 'Today';
  } else if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day - 1) {
    return 'Yesterday';
  } else {
    return 'Older';
  }
}

String _getMonthName(int month) {
  // Map month numbers to month names
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

String _formatTime(DateTime dateTime) {
  // Format time as per AM/PM format
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';
  int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  String minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}