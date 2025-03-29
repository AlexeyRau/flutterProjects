Map<String, String> parseDateTime(String icsDateTime) {
  try {
    final datePart = icsDateTime.length > 8 
      ? '${icsDateTime.substring(0, 4)}-'
        '${icsDateTime.substring(4, 6)}-'
        '${icsDateTime.substring(6, 8)}' 
      : '';
    
    final timePart = icsDateTime.contains('T') && icsDateTime.length > 13
      ? '${icsDateTime.substring(9, 11)}:${icsDateTime.substring(11, 13)}'
      : '';
    
    return {'date': datePart, 'time': timePart};
  } catch (e) {
    return {'date': '', 'time': ''};
  }
}

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime getCurrentMonday(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}