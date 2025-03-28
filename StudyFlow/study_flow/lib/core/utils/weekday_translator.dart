class WeekdayTranslator {
  static const Map<String, String> _translations = {
    'Monday': 'Понедельник',
    'Tuesday': 'Вторник',
    'Wednesday': 'Среда',
    'Thursday': 'Четверг',
    'Friday': 'Пятница',
    'Saturday': 'Суббота',
  };

  static String translate(String englishWeekday) {
    return _translations[englishWeekday] ?? englishWeekday;
  }
}